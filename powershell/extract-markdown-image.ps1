# 需求：
# 该脚本可以解析一个 markdown 文件中引用的所有本地图片的路径，并将它们拷贝到指定文件夹内。
# 从而方便 markdown 文件的迁移
# configs:
# absolute path of the markdown file
$filePath = "D:\CODES(daima)\script-house\test\a.md"
# where to copy?
$destFolder = ".\imgs\"
# ==========================================================

# https://stackoverflow.com/questions/14482253/utf8-script-in-powershell-outputs-incorrect-characters


# folder of the file 
$dirPath = Split-Path -Path $filePath
# Write-Output $dirPath

$content = Get-Content $filePath -Encoding UTF8

$regexList = @(
    # <img src="MarkDownImages/b.jpg" alt="b" style="zoom:50%;" />
    '<img src="([^"]*)" alt=[^/>]* />', 
    # ![img](MarkDownImages/a.png)
    '!\[[\S]*\]\(([\S]*)\)'
)



if (-not $(Test-Path -Path $destFolder)) {
    mkdir $destFolder | Out-Null
}

$count = 0
foreach ($line in $content) {
    foreach ($regex in $regexList) {
        $result = [regex]::matches($line, $regex)

        for ($i = 0; $i -lt $result.Count; $i++) {
            $imgPath = $result[$i].Groups[1]
            # Write-Host $imgPath -ForegroundColor Red
            $imgPath = Join-Path $dirPath $imgPath
            # need to phrase path like: abc/../def
            $imgPath = $(New-Object System.Uri($imgPath)).LocalPath
            # Write-Output $imgPath

            if (-not $(Test-Path -Path $imgPath -PathType Leaf)) {
                Write-Host "image does not exist, bad reference in markdown: $($imgPath)" -ForegroundColor Red
                continue
            }
            else { $count++ }

            Copy-Item "$imgPath" -Destination "$destFolder"
        }
    }
}


Write-Output "=================================="
Write-Output "total copied: $($count)"