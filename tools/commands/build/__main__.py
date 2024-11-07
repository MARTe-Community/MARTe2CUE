"""Project builder"""

import argparse
import logging
import os
import subprocess
import sys

import yaml

CWD = os.path.split(os.path.realpath(__file__))[0]


def args():
    """Argument parser."""
    parser = argparse.ArgumentParser(
        prog="Project Builder", description="Build a CUE MARTe Configuration Project"
    )
    parser.add_argument("path", help="project folder")
    parser.add_argument(
        "--cue",
        default="${cwd}/../cue/cue",
        help="cue executable (default `tools/cue`)",
    )
    parser.add_argument(
        "--log",
        choices=["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"],
        default="WARNING",
        help="Log level (default `WARNING`)",
    )
    parser.add_argument("--env", help="Environment variables yaml file")
    parser.add_argument(
        "--out", help="generated configuration file custom path", type=str
    )
    parser.add_argument("--compile_only", help="Compile only flag", action="store_true")
    parser.add_argument(
        "--update_only",
        help="Update dependecies and interface only flag",
        action="store_true",
    )
    return parser.parse_args()


def process_env(env_file):
    if env_file is None:
        return {}
    env_var = {}
    with open(env_file, "r") as env_f:
        env_cfg = yaml.safe_load(env_f)
        for k, v in env_cfg.items():
            if isinstance(v, dict):
                for sk, val in v.items():
                    logging.info(f"tag `{k}_{sk}` has value `{val}`")
                    env_var[f"{k}_{sk}"] = val
            else:
                logging.info(f"tag `{k}` has value `{v}`")
                env_var[k] = v
    return env_var


def convert_env(env_cfg):
    env = []
    for k, v in env_cfg.items():
        env += ["-t", f"{k}={v}"]
    return env


def fatal_error(msg):
    logging.error(msg)
    sys.exit(1)


def process_interface(name, cfg, app, package, path, cwd):
    interface = cfg["interface"]
    mode = cfg["mode"]
    address = cfg["address"]
    source = os.path.join(path, cfg["source"])
    topic = cfg["topic"] if "topic" in cfg else "Ignored"
    output = cfg["output"] if "output" in cfg else f"{name}.cue"
    target = os.path.join(path, output)
    command = [
        "python3",
        f"{cwd}/../sdn_interface",
        "--app",
        app,
        "--interface",
        interface,
        "--address",
        address,
        "--topic",
        topic,
        "--name",
        name,
        source,
        package,
        mode,
    ]
    if "patterns" in cfg:
        for pattern in cfg["patterns"]:
            command += ["--pattern", pattern]
    logging.info(f"generating interface `{name}`")
    ret = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if ret.returncode != 0:
        fatal_error(
            f"Something went wrong when creating interface `{name}`\n\t"
            + ret.stderr.decode("utf8")
        )
    with open(target, "w") as if_out:
        logging.info(f"saving interface `{name}`")
        if_out.write(ret.stdout.decode("utf8"))


def setup_logger(argv):
    numeric_level = getattr(logging, argv.log, None)
    if not isinstance(numeric_level, int):
        raise ValueError("Invalid log level: %s" % argv.log)
    logging.basicConfig(level=numeric_level)


def lab_key(label):
    return "${" + label + "}"


def process_project_file(argv, cue_cmd, env_var):
    if not os.path.exists(argv.path):
        fatal_error(f"Project path `{argv.path}` does not exist")
    yaml_path = os.path.join(argv.path, "project.yml")
    logging.info(f"project path: `{yaml_path}`")
    if not os.path.exists(yaml_path):
        fatal_error(f"Missing yaml project file `{yaml_path}`")
    validator = os.path.join(CWD, "validator.cue")
    logging.info("validate project file using cue")
    res = subprocess.run([cue_cmd, "vet", validator, yaml_path])
    if res.returncode != 0:
        fatal_error("project file validation failed [see log above]")
    else:
        logging.info("project validation done")
    with open(yaml_path, "r") as prj_file:
        raw_file = prj_file.read()
        all_vars = dict(env_var)
        for label, value in all_vars.items():
            key = lab_key(label)
            if key in raw_file:
                raw_file = raw_file.replace(lab_key(label), str(value))
                del env_var[label]
        conf = yaml.safe_load(raw_file)
        if "project" not in conf:
            fatal_error("Project file malformed (missing project key)")
        logging.info("project loaded")
        return conf["project"]
    fatal_error("something went wrong processing the projectfile")


def load_dependencies(prj_cfg, argv):
    if "dependencies" in prj_cfg:
        logging.info("setting up dependencies")
        for dep_name in prj_cfg["dependencies"]:
            dep = prj_cfg["dependencies"][dep_name]
            logging.info(f"loading {dep_name}")
            if "branch" in dep:
                branch = dep["branch"]
            else:
                branch = None
            source = dep["source"]
            target = os.path.join(argv.path, dep["target"])

            if os.path.exists(target) and len(os.listdir(target)) > 0:
                command = ["rm", "-rf", target]
                ret = subprocess.run(command)
                if ret.returncode != 0:
                    fatal_error(f"Impossible to delete folder `{target}`")

            command = ["git", "clone", "--depth=1"]
            if branch is not None:
                command += ["--branch", branch]
            command += [source, target]
            ret = subprocess.run(["mkdir", "-p", target])
            if ret.returncode != 0:
                fatal_error(
                    f"impossible to create depenency `{dep_name}` target folder `{target}`"
                )
            ret = subprocess.run(command)
            if ret.returncode != 0:
                command = " ".join(command)
                fatal_error(
                    f"checkout of dependency `{dep_name}` failed:\n\t`{command}`"
                )


def load_interfaces(prj_cfg, argv):
    if "interfaces" in prj_cfg:
        logging.info("setting up interfaces")
        interfaces = prj_cfg["interfaces"]
        package = prj_cfg["package"]
        appname = prj_cfg["application"] if "application" in prj_cfg else "RTApp"
        for if_name in interfaces:
            process_interface(
                if_name, interfaces[if_name], appname, package, argv.path, CWD
            )


def build_intermediate_json(prj_cfg, cue_cmd, env, argv):
    package = prj_cfg["package"]
    command = [cue_cmd, "export", "-p", package] + convert_env(env)
    logging.info("Generating intermediate json")
    logging.debug(f"{' '.join(command)}")
    ret = subprocess.run(
        command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, cwd=argv.path
    )
    if ret.returncode != 0:
        fatal_error(
            "Generation of the intermediate json failed\n\t" + ret.stderr.decode("utf8")
        )
    return ret.stdout


def postprocess_json(intermediate):
    command = ["python3", f"{CWD}/../convert"]
    logging.info("Generating final json")
    ret = subprocess.run(
        command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, input=intermediate
    )
    if ret.returncode != 0:
        fatal_error(
            "Generation of the final json failed\n\t" + ret.stderr.decode("utf8")
        )
    return ret.stdout


def export_json(final, prj_cfg, argv):
    if "output" in prj_cfg:
        if not argv.out:
            dest = prj_cfg["output"]
            dest = os.path.join(argv.path, dest)
        else:
            dest = argv.out
        logging.info(f"saving final json configuration to `{dest}`")
        dest_dir = os.path.split(dest)[0]
        if dest_dir:
            ret = subprocess.run(["mkdir", "-p", dest_dir])
            if ret.returncode != 0:
                fatal_error(f"impossible to create destination folder `{dest_dir}`")
        with open(dest, "wb") as dest_file:
            dest_file.write(final)
    else:
        print(final.decode("utf8"))


def main():
    """Main entry point."""
    argv = args()
    cue_cmd = argv.cue.replace("${cwd}", CWD)
    setup_logger(argv)
    env = process_env(argv.env)
    prj_cfg = process_project_file(argv, cue_cmd, env)
    if not argv.compile_only:
        load_dependencies(prj_cfg, argv)
        load_interfaces(prj_cfg, argv)
    if not argv.update_only:
        intermediate = build_intermediate_json(prj_cfg, cue_cmd, env, argv)
        final = postprocess_json(intermediate)
        export_json(final, prj_cfg, argv)


if __name__ == "__main__":
    main()
