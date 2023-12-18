import os


def assert_is_file(path: str):
    if not os.path.isfile(path):
        raise Exception(f"not a valid file path: {path}")


def assert_is_dir(path: str):
    if not os.path.isdir(path):
        raise Exception(f"not a valid directory: {path}")


def winapi_path(path: str):
    """
    Regular DOS paths are limited to MAX_PATH (260) characters. When the size exceeds this limit,
    some python packages may raise FileNotFoundError, e.g. zipfile.ZipFile().extract().
    In such cases, wrap the path with this function will help.

    see:
    https://stackoverflow.com/questions/36219317/pathname-too-long-to-open/36237176
    """
    path = os.path.abspath(path)
    if path.startswith(u"\\\\"):
        return u"\\\\?\\UNC\\" + path[2:]
    return u"\\\\?\\" + path
