import os


def assert_is_file(path: str):
    if not os.path.isfile(path):
        raise Exception(f"not a valid file path: {path}")


def assert_is_dir(path: str):
    if not os.path.isdir(path):
        raise Exception(f"not a valid directory: {path}")
