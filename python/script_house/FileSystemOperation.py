import os
import random
from datetime import datetime


def random_open(directory: str = None,
                file_name_list: [str] = None,
                exclude_files: [str] = None,
                program_path: str = "",
                log_file: str = "RandomOpenLog.txt"):
    if not ((directory is None) ^ (file_name_list is None)):
        raise Exception("directory and file_name_list cannot be both None, nor can they both have values")

    if directory is not None:
        if not os.path.isdir(directory):
            raise Exception(f"not a valid directory: {directory}")
        file_name_list = os.listdir(directory)

    if file_name_list is not None:
        for file in file_name_list:
            if not os.path.isfile(file):
                raise Exception(f"not a valid file name: {file}")

    if exclude_files is None:
        exclude_files = []
    exclude_files = set(exclude_files)

    if not os.path.isfile(program_path):
        raise Exception(f"not a valid program path: {program_path}")

    # List files, count valid files
    valid_files = [name for name in file_name_list if name not in exclude_files]
    valid_num = len(valid_files)

    if valid_num == 0:
        raise Exception("no file to open")

    # random choose one
    index = random.randint(0, valid_num - 1)
    name = valid_files[index]
    print(f'chosen file: {name}')

    with open(log_file, 'a', encoding='utf-8') as log:
        log.write(f"{datetime.now()}\n")
        log.write(f"chosen file: {name}\n")
        log.write("============================\n\n")

    if program_path == "":
        os.system(f'"{name}"')
    else:
        os.system(f'{program_path} "{name}"')

    print("all done")
