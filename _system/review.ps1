<#
  review.ps1 - build + render a one-page contact sheet of every PNG in an article folder.

  QA trick that scales: read ONE montage instead of opening five PNGs one at a time.

  Usage:
    .\_system\review.ps1 -Path ".\<Brand>\<article-slug>"

  Output: <folder>\_review.html and <folder>\_review.png (QA only - not a deliverable).

  KEEP THIS FILE PURE ASCII. Windows PowerShell 5.1 reads a UTF-8-without-BOM .ps1 as cp1252, so a
  single em dash or curly quote turns into mojibake and the whole script fails to PARSE.
#>
param(
  [Parameter(Mandatory=$true)][string]$Path,
  [int]$Cols = 3,
  [int]$CellH = 330
)

. (Join-Path $PSScriptRoot 'find-browser.ps1')

$dir  = (Resolve-Path -LiteralPath $Path).Path
$name = Split-Path $dir -Leaf
$pngs = @(Get-ChildItem -LiteralPath $dir -Filter *.png | Where-Object { $_.Name -notlike '_*' } | Sort-Object Name)
if ($pngs.Count -eq 0) { throw "No PNGs in $dir - render first." }

$cards = ($pngs | ForEach-Object {
  '<div class="c"><b>' + [IO.Path]::GetFileNameWithoutExtension($_.Name) +
  '</b><div class="box"><img src="' + $_.Name + '"></div></div>'
}) -join "`n"

$css = @'
*{margin:0;padding:0;box-sizing:border-box}
body{width:1700px;background:#fff;font-family:Inter,system-ui,sans-serif;padding:24px}
h1{font-size:22px;margin-bottom:14px}
.c{border:1px solid #dde1e8;border-radius:10px;padding:10px}
.c b{font-size:14px}
img{max-width:100%;max-height:100%;object-fit:contain}
'@
# grid rules are built by hand so no CSS function call sits inside an interpolated string
$css += ".g{display:grid;grid-template-columns:repeat($Cols,1fr);gap:16px}`n"
$css += ".box{height:${CellH}px;display:flex;align-items:center;justify-content:center;background:#f7f8fa;border-radius:6px;margin-top:8px}`n"

$html = '<!DOCTYPE html><html><head><meta charset="UTF-8"><style>' + $css +
        '</style></head><body><h1>' + $name + '</h1><div class="g">' + $cards + '</div></body></html>'

# byte-safe write - never Set-Content, which defaults to the ANSI codepage
$reviewHtml = Join-Path $dir '_review.html'
[IO.File]::WriteAllText($reviewHtml, $html, (New-Object Text.UTF8Encoding $false))

# height must cover every row or the last one is silently cropped
$rows = [math]::Ceiling($pngs.Count / $Cols)
$h    = 70 + ($rows * ($CellH + 62)) + 24

$browser = Find-Browser
$profileDir = Join-Path ([IO.Path]::GetTempPath()) ("review_" + [Guid]::NewGuid().ToString('N'))
$uri = ([Uri]$reviewHtml).AbsoluteUri
$out = Join-Path $dir '_review.png'

$argline = '--headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=1 ' +
           "--window-size=1700,$h --virtual-time-budget=6000 --disk-cache-size=1 " +
           '--user-data-dir="' + $profileDir + '" --screenshot="' + $out + '" "' + $uri + '"'
Start-Process -FilePath $browser -ArgumentList $argline -Wait -NoNewWindow
try { Remove-Item -LiteralPath $profileDir -Recurse -Force -ErrorAction Stop } catch {}

Write-Output "$name -> _review.png  ($($pngs.Count) images, $rows rows)"
