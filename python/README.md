# pypi

https://pypi.org/project/script-house/

# 如何本地安装

```shell
python.exe .\setup.py bdist_wheel sdist
pip install .
```

# 如何上传到 pypi
1. 拿 `api_token`

2. 创建 .pypirc 文件，放到 `$HOME` 目录（Windows 的话，放到 `C:\Users\用户名` 下）
    .pypirc 格式：
    
    ```ini
    [pypi]
      username = __token__
      password = <api_token>
    ```
    
3. `pip install wine`

4. 上传：`twine upload dist/*`
