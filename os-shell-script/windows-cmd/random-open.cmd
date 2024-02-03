@echo off
REM 需求：假设有一个『电影』文件夹，里面有很多没看过的电影，我们想要随机打开一部电影
REM 同理，我们可能想要随机打开一张照片、一个游戏等
REM 因此，该脚本的作用是使用一个软件打开当前文件夹下的一个随机文件
REM
REM ==========================================================
REM configs:
REM the program path to open the randomly chosen file
REM set the value to "" to open file by default program
set programPath=""
REM ==========================================================

REM list all the files (exclude this script) in current folder to a temp file
set tempFilePath=%TMP%\random-open-1-%RANDOM%-%RANDOM%.txt
dir /b /a-d | findstr /v /i "random-open.cmd" > %tempFilePath%

REM count the number of lines in the temp file
for /F %%C in ('^< "%tempFilePath%" find /C /V ""') do set "COUNT=%%C"

REM random choose a index by using universal hash family
set a=%random%
set b=%random%
REM p is a prime greater than max(random)
set p=42023
set /a index=((%a% * %random% + %b%) %% %p%) %% %COUNT% + 1

REM get the name of the randomly chose file
set fileChosen=""
for /f "tokens=1* delims=:" %%i in ('findstr /n .* "%tempFilePath%"') do (
    if "%%i"=="%index%" (
        set fileChosen=%%j
        goto :end_loop
    )
)
:end_loop

del %tempFilePath%

REM open the file
start %programPath% "%fileChosen%"