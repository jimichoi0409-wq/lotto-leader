# 앱 아이콘·시작 화면 이미지 생성 (Windows 기본 System.Drawing 사용, 별도 설치 불필요)
#
# 사용법 (lotto_app 폴더에서):
#   powershell -ExecutionPolicy Bypass -File tool\make_icons.ps1
# 원본: tool\icon_source.png (정사각형, 512px 이상 권장. 1024px 원본이 있으면 교체하세요)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$root = Split-Path -Parent $PSScriptRoot
$src = [System.Drawing.Image]::FromFile((Join-Path $PSScriptRoot 'icon_source.png'))

function New-Canvas([int]$size, [bool]$alpha) {
    $fmt = if ($alpha) { [System.Drawing.Imaging.PixelFormat]::Format32bppArgb } else { [System.Drawing.Imaging.PixelFormat]::Format24bppRgb }
    $bmp = New-Object System.Drawing.Bitmap($size, $size, $fmt)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
    return @($bmp, $g)
}

# 정사각형 아이콘 (투명도 없음: iOS 앱 아이콘은 알파 채널이 있으면 거부됨)
function Save-Square([string]$path, [int]$size, [bool]$alpha = $false) {
    $bmp, $g = New-Canvas $size $alpha
    $attr = New-Object System.Drawing.Imaging.ImageAttributes
    $attr.SetWrapMode([System.Drawing.Drawing2D.WrapMode]::TileFlipXY)  # 가장자리 번짐 방지
    $g.DrawImage($src, (New-Object System.Drawing.Rectangle(0, 0, $size, $size)), 0, 0, $src.Width, $src.Height, [System.Drawing.GraphicsUnit]::Pixel, $attr)
    New-Item -ItemType Directory -Force (Split-Path -Parent $path) | Out-Null
    $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose(); $bmp.Dispose()
}

# 둥근 모서리 아이콘 (시작 화면용, 바깥은 투명)
function Save-Rounded([string]$path, [int]$size) {
    $bmp, $g = New-Canvas $size $true
    $r = [int]($size * 0.22)
    $gp = New-Object System.Drawing.Drawing2D.GraphicsPath
    $gp.AddArc(0, 0, 2 * $r, 2 * $r, 180, 90)
    $gp.AddArc($size - 2 * $r, 0, 2 * $r, 2 * $r, 270, 90)
    $gp.AddArc($size - 2 * $r, $size - 2 * $r, 2 * $r, 2 * $r, 0, 90)
    $gp.AddArc(0, $size - 2 * $r, 2 * $r, 2 * $r, 90, 90)
    $gp.CloseFigure()
    $brush = New-Object System.Drawing.TextureBrush($src)
    $scale = $size / $src.Width
    $brush.ScaleTransform($scale, $scale)
    $g.FillPath($brush, $gp)
    New-Item -ItemType Directory -Force (Split-Path -Parent $path) | Out-Null
    $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $brush.Dispose(); $gp.Dispose(); $g.Dispose(); $bmp.Dispose()
}

$res = Join-Path $root 'android\app\src\main\res'

# ---- Android 기존 방식 아이콘 (48dp) ----
$dens = @{ 'mdpi' = 1.0; 'hdpi' = 1.5; 'xhdpi' = 2.0; 'xxhdpi' = 3.0; 'xxxhdpi' = 4.0 }
foreach ($d in $dens.Keys) {
    $f = $dens[$d]
    Save-Square (Join-Path $res "mipmap-$d\ic_launcher.png") ([int](48 * $f))
    # 적응형 아이콘 전경 (108dp, 가운데 72dp 만 보임)
    Save-Square (Join-Path $res "mipmap-$d\ic_launcher_foreground.png") ([int](108 * $f))
    # Android 11 이하 시작 화면 로고 (128dp, 둥근 모서리)
    Save-Rounded (Join-Path $res "drawable-$d\splash_logo.png") ([int](128 * $f))
}

# ---- iOS 앱 아이콘 ----
$ios = Join-Path $root 'ios\Runner\Assets.xcassets\AppIcon.appiconset'
$iosIcons = @{
    'Icon-App-20x20@1x.png' = 20; 'Icon-App-20x20@2x.png' = 40; 'Icon-App-20x20@3x.png' = 60
    'Icon-App-29x29@1x.png' = 29; 'Icon-App-29x29@2x.png' = 58; 'Icon-App-29x29@3x.png' = 87
    'Icon-App-40x40@1x.png' = 40; 'Icon-App-40x40@2x.png' = 80; 'Icon-App-40x40@3x.png' = 120
    'Icon-App-60x60@2x.png' = 120; 'Icon-App-60x60@3x.png' = 180
    'Icon-App-76x76@1x.png' = 76; 'Icon-App-76x76@2x.png' = 152; 'Icon-App-83.5x83.5@2x.png' = 167
    'Icon-App-1024x1024@1x.png' = 1024
}
foreach ($name in $iosIcons.Keys) { Save-Square (Join-Path $ios $name) $iosIcons[$name] }

# ---- iOS 시작 화면 로고 (120pt) ----
$launch = Join-Path $root 'ios\Runner\Assets.xcassets\LaunchImage.imageset'
Save-Rounded (Join-Path $launch 'LaunchImage.png') 120
Save-Rounded (Join-Path $launch 'LaunchImage@2x.png') 240
Save-Rounded (Join-Path $launch 'LaunchImage@3x.png') 360

# ---- 스토어 등록용 ----
$store = Join-Path (Split-Path -Parent (Split-Path -Parent $root)) '5_store_assets'
Save-Square (Join-Path $store 'play_store_icon_512.png') 512 $true
Save-Square (Join-Path $store 'app_store_icon_1024.png') 1024

$src.Dispose()
Write-Output 'icons done'
