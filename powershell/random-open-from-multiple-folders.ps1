# 需求：假设有一个『电影』文件夹，里面有很多按照年份归类的电影，目录结构如下：
# film:
#   - 1970
#     - a.avi
#     - b.avi
#     - c.avi
#   - 1971
#     - d.avi
#   - 2023
#     - x.avi
# 我们想要在这些电影中随机打开一部
# 同理，我们可能想要随机打开一张照片、一个游戏等
# 因此，该脚本的作用是使用一个软件打开 多个 文件夹下的一个随机文件
# ====================================================
# 该脚本的作用比 ./random-open.ps1 更加强大，因为从多个文件夹中随机选择一个
# 文件难度比从一个文件夹中选择难度更大。因此这个脚本是一个在实现类似功能时很好的参考
# 
# 我们不能先随机选择一个文件夹，再随机选择其中的一个文件，因为这假设了每一个文件夹中的文件数量都相同
# ==========================================================
# configs:
# the program path to open the randomly chosen file
# the value to "" to open file by default program
$programPath = ""
# 从哪些文件夹下选择一个随机文件？
# 默认为当前目录下的所有文件夹，也可以自己指定
$includeFolders = @('..\test\films\1966', '..\test\films\1972', '..\test\films\1973', '..\test\films\1974', '..\test\films\.git')
# $includeFolders = $(Get-ChildItem -Directory).Name

# there may be some folders you  want to exclude
# input their names as the entries of the array
$excludeFolders = @(
    '..\test\films\.git'
)
# ==========================================================

# 0. convert folder names into absoulte path
for ($i = 0; $i -lt $includeFolders.Length; $i++) {
    if ([System.IO.Path]::IsPathRooted($includeFolders[$i])) {
        continue
    }
    $includeFolders[$i] = Join-Path $(pwd) $includeFolders[$i]
    $includeFolders[$i] = $(New-Object System.Uri($includeFolders[$i])).LocalPath
}

for ($i = 0; $i -lt $excludeFolders.Length; $i++) {
    if ([System.IO.Path]::IsPathRooted($excludeFolders[$i])) {
        continue
    }
    $excludeFolders[$i] = Join-Path $(pwd) $excludeFolders[$i]
    $excludeFolders[$i] = $(New-Object System.Uri($excludeFolders[$i])).LocalPath
}


# 1. combine includeFolders and excludeFolders
$map = @{}
foreach ($path in $excludeFolders) {
    $map[$path] = ""
}
$excludeFolders = $map

$map = @{}
foreach ($path in $includeFolders) {
    if (-not $excludeFolders.ContainsKey($path)) {
        $map[$path] = ""
    }
}
$includeFolders = $map

# 2. count number of files in each folder included, remove those with no files in them
$map = @{}
foreach ($path in $includeFolders.Keys) {
    $val = $(( Get-ChildItem -LiteralPath $path | Measure-Object ).Count)
    if ($val -gt 0) {
        $map[$path] = $val
    }
}
$includeFolders = $map

# 3. make <path, count> into 2 arrays
# count prefix sum and total count
$pathList = @(1..$($includeFolders.Count + 1))
$prefixSum = @(1..$($includeFolders.Count + 1))
$prefixSum[0] = 0
$i = 1
$validNum = 0
foreach ($path in $includeFolders.Keys) {
    $prefixSum[$i] = $includeFolders[$path] + $prefixSum[$i - 1]
    $pathList[$i] = $path    
    $validNum += $includeFolders[$path]
    $i++
}

# 4. random choose a index by using universal hash family
# assume  $validNum < 900,000
$a = Get-Random -Maximum 900000
$b = Get-Random -Maximum 900000
# p is a prime greater than max(a, b)
$p = 900019
$index = (($a * $(Get-Random -Maximum 900000) + $b) % $p) % $validNum + 1

# 5. choose the target folder
$targetFolder = ""
for ($i = 1; $i -lt $prefixSum.Length; $i++) {
    if (($prefixSum[$i - 1] -lt $index) -and ($index -le $prefixSum[$i])) {
        $targetFolder = $pathList[$i]
        # index now points to the speific file in the $targetFolder
        $index -= $prefixSum[$i - 1]
        $index--
        Write-Output "chosen folder: $($targetFolder)"
        break
    }
}


# 6. open the file 
$files = $(Get-ChildItem -File -LiteralPath $targetFolder).Name
# when there is only 1 file in the folder, $files will be an object, not an array
# we should convert it into an array
if ($files -isnot [Object[]]) {
    $files = @($files)
}
$targetFile = Join-Path $targetFolder $files[$index]
Write-Output "chosen file: $($files[$index])"

if ("" -eq $programPath) { Start-Process $targetFile }
else { Start-Process $programPath $targetFile }

Write-Output "all done"
