import subprocess

from . import SystemUtils
from .FileSystemUtils import assert_is_file


class BaseArchiveUtils:
    _exe = None

    def __init__(self, path: str = None):
        if path is not None:
            self._exe = path
        assert_is_file(self._exe)


class SevenZipUtils(BaseArchiveUtils):
    def __init__(self, path: str = None):
        super().__init__(path)

    def extract(self, archive: str, output_dir: str = None) -> subprocess.CompletedProcess:
        assert_is_file(archive)
        cmd = f'{self._exe} x "{archive}" '
        if output_dir is not None:
            cmd += f'-o"{output_dir}"'
        return SystemUtils.run(cmd)


class RARUtils(BaseArchiveUtils):
    def __init__(self, path: str = None):
        super().__init__(path)

    def extract(self, archive: str, output_dir: str = None) -> subprocess.CompletedProcess:
        assert_is_file(archive)
        cmd = f'{self._exe} x "{archive}" '
        if output_dir is not None:
            output_dir = output_dir.strip()
            # 必须使用附加的倒斜线来表示目标文件夹
            if output_dir[-1] != '\\':
                output_dir += '\\'
            cmd += f' "{output_dir}"'
        print(cmd)
        return SystemUtils.run(cmd)
