import os
import random
from datetime import datetime


def random_open(directory: str = None,
                file_list: [str] = None,
                exclude_file_names: [str] = None,
                program_path: str = "",
                log_file: str = "RandomOpenLog.txt") -> None:
    """
    需求：假设有一个『电影』文件夹，里面有很多没看过的电影，我们想要随机打开一部电影。同理，我们可能想要随机打开一张照片、一个游戏等。

    本函数的作用是使用指定程序随机打开一个某目录下的文件.

    :param directory: 该目录下的所有文件都可能被随机打开.
    :param file_list: 指定需要被随机打开的文件名（文件路径）列表.
    :param exclude_file_names: 如果使用 directory 参数，有一些文件可能不需要被打开.
    :param program_path: 要用哪个程序打开文件.
    :param log_file: 记录过往随机打开的文件.
    """
    if not ((directory is None) ^ (file_list is None)):
        raise Exception("directory and file_name_list cannot be both None, nor can they both have values")

    if directory is not None:
        if not os.path.isdir(directory):
            raise Exception(f"not a valid directory: {directory}")
        file_list = os.listdir(directory)

    if file_list is not None:
        for file in file_list:
            if not os.path.isfile(file):
                raise Exception(f"not a valid file name: {file}")

    if exclude_file_names is None:
        exclude_file_names = []
    exclude_file_names = set(exclude_file_names)

    if not os.path.isfile(program_path):
        raise Exception(f"not a valid program path: {program_path}")

    # List files, count valid files
    valid_files = [name for name in file_list if name not in exclude_file_names]
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
