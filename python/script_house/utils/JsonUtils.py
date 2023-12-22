import json
from .FileSystemUtils import assert_is_file
from os.path import isfile


def write(obj, file: str, force_write: bool = False):
    if isfile(file) and not force_write:
        raise Exception(f'file already exists, but force write is not allowed.')

    with open(file, 'w', encoding='utf-8') as f:
        json.dump(obj, f, ensure_ascii=False, indent=4)


def read(file: str):
    assert_is_file(file)
    with open(file, 'r', encoding='utf-8') as f:
        obj = json.load(f)
    return obj


def to_str(obj):
    return json.dumps(obj, ensure_ascii=False, indent=4)


def to_obj(string: str):
    return json.loads(string)
