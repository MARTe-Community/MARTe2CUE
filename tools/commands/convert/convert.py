import json
import sys
import copy
import logging 
import argparse

from collections import OrderedDict

from processors import Processors, clean_private
from processors import clean_empty, marte_syntax


def args():
    """Argument parser."""
    parser = argparse.ArgumentParser(
                        prog="MARTeConfigurer",
                        description="Convert CUE generated JSON in the final MARTe Configuration")
    parser.add_argument("--log", choices=["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"], default="WARNING")
    return parser.parse_args()


def main():
    """Main entry point."""
    argv = args()
    numeric_level = getattr(logging, argv.log, None)
    if not isinstance(numeric_level, int):
        raise ValueError('Invalid log level: %s' % argv.log)
    logging.basicConfig(level=numeric_level)

    json_in = sys.stdin.read()
    if not json_in:
        logging.error('no input buffer detected.')
        sys.exit(1)
    try:
        original = json.loads(json_in, object_pairs_hook=OrderedDict)
    except json.JSONDecodeError:
        logging.error('input buffer is not a valid JSON file.')
        sys.exit(1)
    logging.info('JSon loaded')
    if '$root' not in original:
        logging.info('No $root element')
        doc_root = original
    else:
        doc_root = original['$root']
    output = copy.deepcopy(doc_root)
    for el_name in output:
        root = output[el_name]
        if 'Class' not in root:
            logging.error(f"root element `{el_name}` has no attribute 'Class'")
            sys.exit(1)
        if root['Class'] in Processors:
            logging.info(f'processing {el_name}')
            root = Processors[root['Class']](root, doc_root)
        else:
            logging.info(f"class `{root['Class']}` could be not fully supported")
            root = Processors["**"](root, doc_root)
    output = clean_private(output)
    output = clean_empty(output)
    output = marte_syntax(output)
    print(json.dumps(output, indent=4))


if __name__ == "__main__":
    main()

