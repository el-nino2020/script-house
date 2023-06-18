@echo off
REM 在当前目录下生成一个随机文本文件
REM 随机文本文件有什么用？
REM 对于云盘中的压缩包，为了防止丢失，我们应该下载到本地，再重新压缩，然后上传
REM 如果要压缩的内容相同，则生成的是同一个压缩包。
REM 只要随便改变一个文件，生成的就是不同的压缩包。
REM 怎么随机改变？添加一个随机文本文件
REM ================================
REM configs:
REM path of git-bash.exe
set gitBashPath=""
REM ================================

set randomFileName=.\random-file-%RANDOM%-%RANDOM%.txt
%gitBashPath% -c "openssl rand -base64 3000 > %randomFileName% "