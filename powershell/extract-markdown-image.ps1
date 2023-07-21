# 需求：
# 该脚本可以解析一个 markdown 文件中引用的所有本地图片的路径，并将它们拷贝/剪切到指定文件夹内。
# 从而方便 markdown 文件的迁移
# ==========================================================
# configs:
# absolute path of the markdown file
$filePath = ""
# where to copy?
$destFolder = ".\MarkDownImages\"
# 是否剪切，而不是拷贝图片
# 注意：剪切操作是不可逆的，应当谨慎使用，尤其当 markdown 引用了不同路径下的图片时
$cutInsteadOfCopy = $false
# ==========================================================

# use lazy mode to get multiple matches in a line
$regexList = @(
    # <img src="MarkDownImages/b.jpg" alt="b" style="zoom:50%;" />
    '<img src="(.*?)" alt=.*? />', 
    # ![img](MarkDownImages/a.png)
    '!\[.*?\]\((.*?)\)'
)


# folder of the file 
$dirPath = Split-Path -Path $filePath

if (-not $(Test-Path -Path $destFolder)) {
    mkdir $destFolder | Out-Null
}

$count = 0
$content = Get-Content $filePath -Encoding UTF8

foreach ($line in $content) {
    foreach ($regex in $regexList) {
        $result = [regex]::matches($line, $regex)

        for ($i = 0; $i -lt $result.Count; $i++) {
            $imgPath = $result[$i].Groups[1]
            $imgPath = Join-Path $dirPath $imgPath
            # need to phrase path like: abc/../def
            $imgPath = $(New-Object System.Uri($imgPath)).LocalPath
            # Write-Output $imgPath

            if (-not $(Test-Path -Path $imgPath -PathType Leaf)) {
                Write-Host "image does not exist, bad reference in markdown: $($imgPath)" -ForegroundColor Red
                continue
            } else { $count++ }
            
            if ($cutInsteadOfCopy) {
                Move-Item "$imgPath" -Destination "$destFolder"
            } else {
                Copy-Item "$imgPath" -Destination "$destFolder"
                
            }
        }
    }
}


Write-Output "=================================="
Write-Output "total copied: $($count)"