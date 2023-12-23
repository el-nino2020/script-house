import json
import inspect

from .FileSystemUtils import assert_is_file
from os.path import isfile
from marshmallow import Schema

"""
The conversion flow:
str <-> built-in types <-> custom class 

(1) str <-> built-in types 
    uses python's default json module
    
(2) built-in types <-> custom class 
    uses marshmallow_dataclass and requires the custom class annotated with @marshmallow_dataclass.dataclass
"""


def get_marshmallow_dataclass_schema(clazz: type) -> Schema:
    if not inspect.isclass(clazz):
        raise Exception(f'not a class: {clazz}')
    if len([method for method in dir(clazz) if method == 'Schema']) == 0:
        raise Exception(f'annotate {clazz} with @marshmallow_dataclass.dataclass first')
    return clazz.Schema()


def write(obj, file: str, force_write: bool = False, clazz: type = None):
    if isfile(file) and not force_write:
        raise Exception(f'file already exists, but force write is not allowed.')

    if clazz is not None:
        obj = get_marshmallow_dataclass_schema(clazz).dump(obj)

    with open(file, 'w', encoding='utf-8') as f:
        json.dump(obj, f, ensure_ascii=False, indent=4)


def read(file: str, clazz: type = None):
    assert_is_file(file)
    with open(file, 'r', encoding='utf-8') as f:
        obj = json.load(f)

    if clazz is None:
        return obj
    return get_marshmallow_dataclass_schema(clazz).load(obj)


def to_str(obj, clazz: type = None):
    if clazz is not None:
        obj = get_marshmallow_dataclass_schema(clazz).dump(obj)
    return json.dumps(obj, ensure_ascii=False, indent=4)


def to_obj(string: str, clazz: type = None):
    # return a dict
    obj = json.loads(string)
    if clazz is None:
        return obj
    return get_marshmallow_dataclass_schema(clazz).load(obj)
