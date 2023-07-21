# 需求：假设有一个『电影』文件夹，里面有很多没看过的电影，我们想要随机打开一部电影
# 同理，我们可能想要随机打开一张照片、一个游戏等
# 因此，该脚本的作用是使用一个软件打开当前文件夹下的一个随机文件
#
# ====================================================
# 脚本的作用与 ./../windows-cmd/random-open.cmd 相同，
# 但是用 powershell 写应该会方便不少，毕竟后者更支持面向对象
# ==========================================================
# configs:
# the program path to open the randomly chosen file
# the value to "" to open file by default program
$programPath = ""
# there may be some files under this folder you do not want to open
# input their names as the entries of the array
$excludeFiles = @(
    '.gitignore',
    'LICENSE'
)
# ==========================================================

# 1. convert excludeFiles into a map for better search
$map = @{}
foreach ($name in $excludeFiles) {
    $map[$name] = ""
}
$excludeFiles = $map

# 2. list files, count valid files
# $fileNameList = $(Get-ChildItem -Directory).Name
$fileNameList = $(Get-ChildItem -File).Name
$validNum = 0
foreach ($name in $fileNameList) {
    if (-not $excludeFiles.ContainsKey($name)) {
        $validNum = $validNum + 1
    }
}

# 3. random choose a index by using universal hash family
$a = Get-Random -Maximum 42000
$b = Get-Random -Maximum 42000
# p is a prime greater than max(a, b)
$p = 42023
$index = (($a * $(Get-Random -Maximum 42000) + $b) % $p) % $validNum


# 4. open the file
foreach ($name in $fileNameList) {
    if ($excludeFiles.ContainsKey($name)) {
        continue
    }

    if (0 -eq $index) {
        Write-Output "chosen file: $($name)"

        if ("" -eq $programPath) { Start-Process $name }
        else { Start-Process $programPath $name }
        break
    } else { $index = $index - 1 }
}

Write-Output "all done"


