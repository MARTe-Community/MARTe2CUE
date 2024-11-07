"""CSV Interface converter."""

import argparse
import copy
import csv
import logging
import sys
from collections import namedtuple
from datetime import datetime


def args():
    """Argument parser."""
    parser = argparse.ArgumentParser(
        prog="InterfaceConverter",
        description="Convert SDN interface CSV to CUE datasource",
    )
    parser.add_argument("input", help="Input CSV file")
    parser.add_argument("package", help="CUE package")
    parser.add_argument(
        "mode", choices=["SUB", "PUB"], help="Direction of the DataSource (SUB or PUB)"
    )
    parser.add_argument("--interface", help="Physical interface name")
    parser.add_argument("--address", help="IP:PORT address")
    parser.add_argument("--app", default="RTApp", help="RT Application name")
    parser.add_argument(
        "--topic", default="Ignored", help="SDN Topic (default `Ignored`)"
    )
    parser.add_argument(
        "--name", help="DataSource name (if none same name of input file)"
    )
    parser.add_argument(
        "--log",
        choices=["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"],
        default="WARNING",
        help="Log level (default `WARNING`)",
    )
    parser.add_argument(
        "--pattern",
        action="append",
        nargs=1,
        help="remove given name pattern from the signal name",
    )
    return parser.parse_args()


def get_attr(attr):
    if attr is None:
        logging.error("attribute is void")
        sys.exit(1)
    if attr[0] == "$":
        return f"_ @tag({attr[1:]})"
    return f'"{attr}"'


def clean(name, patterns):
    """Progressivily apply clean patterns."""
    if patterns is None:
        return name
    res = name
    for pattern in patterns:
        res = res.replace(pattern[0], "")
    while res[0] in ("-", ":"):
        res = res[1:]
    res = res.replace("-", "_").replace(":", "_")
    return res


def main():
    """Main entry point."""
    argv = args()
    numeric_level = getattr(logging, argv.log, None)
    if not isinstance(numeric_level, int):
        raise ValueError("Invalid log level: %s" % argv.log)
    logging.basicConfig(level=numeric_level)

    signals = []
    Signal = namedtuple("Signal", ["name", "type", "dim", "default", "comment"])
    with open(argv.input, mode="r", encoding="utf-8") as f:
        reader = csv.reader(f)
        for i, row in enumerate(reader):
            if row and not row[0][0] == "#":
                if len(row) == 5:
                    row[0] = clean(row[0], argv.pattern)
                    signals.append(Signal(*row))
                elif len(row) > 5:
                    row[0] = clean(row[0], argv.pattern)
                    logging.warning(
                        f"warning at line {i+1}, length of the row is bigger than 5 (it is {len(row)})"
                    )
                    signals.append(Signal(*row[:5]))
                else:
                    logging.error(
                        f"error at line {i+1}, length of the row is smaller than 5 (it is {len(row)})"
                    )
                    sys.exit(1)
    print("//// Autogenerated Interface ////")
    print(f"// Source: {argv.input}")
    print(f"// Date: {datetime.strftime(datetime.now(), '%Y-%m-%d %H:%M:%S')}")
    print(f"// Tool: MARTeCFG/tools/InterfaceConverter")
    print(f"package {argv.package}\n")
    print(f"import(")
    print(f'\t"marte.org/MARTe"')
    print(f'\t"marte.org/MARTe/components"')
    if any(sig.type == "uint1" for sig in signals):
        print(f'\t"marte.org/MARTe/extensions"')
    print(")")
    print()

    name = argv.input.split("/")[-1].split(".")[0] if argv.name is None else argv.name

    interface = get_attr(argv.interface)
    address = get_attr(argv.address)

    ds = (
        "components.#SDNPublisher"
        if argv.mode == "PUB"
        else "components.#SDNSubscriber"
    )
    print(f"{argv.app}:Data: " + "{")
    print(f"  {name}: {ds} &", "{")
    print(f'    Topic: "{argv.topic}"')
    print(f"    Interface: {interface}")
    print(f"    Address: {address}")
    if argv.mode == "PUB":
        print("    NetworkByteOrder: 1")
    else:
        print('    ExecutionMode: "RealTimeThread"')
        print("    InternalTimeout: 500000000")
        print("    IgnoreTimeoutError: 1")
    print("    Signals: {")

    pad = " " * 6
    bitgroups = []
    current_group = []
    _signals = copy.deepcopy(signals)
    signals = []
    if argv.mode == "SUB":
        signals.append(Signal("Header", "uint8", 48, "NA", "SDN internal header"))
    for signal in _signals:
        if signal.type == "uint1":
            current_group.append(signal)
            if sum(int(sig.dim) for sig in current_group) == 8:
                signame = f"ByteGroup{len(bitgroups)}"
                bitgroups.append((name, signame, copy.deepcopy(current_group)))
                signals.append(Signal(signame, "uint8", 1, "NA", ""))
                current_group = []
        else:
            signals.append(signal)
    for signal in signals:
        print(f"{pad}{signal.name}: MARTe.#{signal.type}", end="")
        if int(signal.dim) > 1:
            print(" & {", f"NumberOfElements: {signal.dim}", "}")
        else:
            print()
    print("    }")
    print("  }")
    if bitgroups:
        defaultDS = f"{name}Bits"

        print(f"  {defaultDS}:", "MARTe.#GAMDataSource", "& {")
        print("    AllowNoProducers: 1")
        print("    Signals: {")
        for name, _, bits in bitgroups:
            for bit in bits:
                print(f"{pad}{bit.name}: MARTe.#uint8", end="")
                if int(bit.dim) > 1:
                    print(" & {", f"NumberOfElements: {bits.dim}", "}")
                else:
                    print()
        print("    }")
        print("  }")
    print("}")

    gams = bitgroups or (
        argv.mode == "PUB" and any(sig.default not in ("NA", "") for sig in signals)
    )

    if gams:
        print(f"{argv.app}: Functions:" + " {")
    if bitgroups:
        if argv.mode == "SUB":
            print(f"  {name}ExtractBitGAM: extensions.#ExtractBitGAM", "& {")
            print("    InputSignals: {")
            for name, sig, _ in bitgroups:
                print(f"{pad}{sig}:", f"#signal: {argv.app}.Data.{name}.#.{sig}")
            print("    }")
            print("    OutputSignals: {")
            for name, _, bits in bitgroups:
                for bit in bits:
                    print(
                        f"{pad}{bit.name}:",
                        f"#signal: {argv.app}.Data.{name}Bits.#.{bit.name}",
                    )
            print("    }")
        else:
            print(f"  {name}CompactBitGAM: extensions.#CompactBitGAM", "& {")
            print("    InputSignals: {")
            for name, _, bits in bitgroups:
                for bit in bits:
                    print(
                        f"{pad}{bit.name}:",
                        f"#signal: {argv.app}.Data.{name}Bits.#.{bit.name}",
                    )
            print("    }")
            print("    OutputSignals: {")
            for name, sig, _ in bitgroups:
                print(f"{pad}{sig}:", f"#signal: {argv.app}.Data.{name}.#.{sig}")
            print("    }")
        print("  }")

    if argv.mode == "PUB" and any(sig.default not in ("NA", "") for sig in signals):
        print(f"  {name}ConstantGAM: components.#ConstantGAM", "& {")
        print("    OutputSignals: {")
        for signal in signals:
            if signal.default not in ("NA", ""):
                print(f"{pad}{signal.name}:", "{")
                print(f"{pad}  #signal: {argv.app}.Data.{name}.#.{signal.name}")
                print(f"{pad}  Default: {signal.default}")
                print(pad + "}")
        print("    }")
        print("  }")
    if gams:
        print("}")


if __name__ == "__main__":
    main()
