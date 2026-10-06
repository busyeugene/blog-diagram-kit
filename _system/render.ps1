<#
  render.ps1 - HTML -> PNG for the in-article diagram kit.

  Ratio is read from the <body> class in each HTML file:
     r169 -> 1200x675   @2x = 2400x1350
     r11  -> 1000x1000  @2x = 2000x2000
     r916 -> 675x1200   @2x = 1350x2400   (deprecated, kept so old files still render)

  Usage:
    .\_system\render.ps1 -Path ".\<Brand>\<article-slug>" -Force     # a folder
    .\_system\render.ps1 -Path ".\_templates" -Force                 # re-render the library
    .\_system\render.ps1 -Path ".\<Brand>\<slug>\01-foo.html" -Force # one file

  IMPORTANT: without -Force, a file whose PNG already exists is SKIPPED (by existence, not by
  timestamp). After editing an image, always pass -Force or you will review the old PNG.

  Browser: Microsoft Edge or Google Chrome, found automatically on Windows, macOS and Linux.
  Override with the DIAGRAM_BROWSER environment variable (full path to the executable).

  Gotchas this script already handles (learned the hard way):
   * Start-Process -Wait - the & call operator returns before headless finishes writing.
   * Single quoted arg-line string - an -ArgumentList array does not quote paths containing
     spaces, and the browser then reads the fragments as extra targets and writes nothing.
   * Unique --user-data-dir per render - a shared profile dir makes the 2nd+ launches hit the
     singleton lock and silently re-emit the previous cached PNG.
   * --virtual-time-budget - webfonts need time to land or you get fallback type.

  KEEP THIS FILE PURE ASCII. Windows PowerShell 5.1 reads a UTF-8-without-BOM .ps1 as cp1252, so a
  single em dash or curly quote breaks the PARSE of the whole file.
#>
param(
  [Parameter(Mandatory=$true)][string]$Path,
  [switch]$Force,                    # re-render even if the PNG already exists
  [int]$Budget = 5000                # virtual-time budget (ms); raise if webfonts look wrong
)

. (Join-Path $PSScriptRoot 'find-browser.ps1')
$browser = Find-Browser

$item = Get-Item -LiteralPath $Path
$files = if ($item.PSIsContainer) { @(Get-ChildItem -LiteralPath $Path -Filter *.html -Recurse | Where-Object { $_.Name -notlike '_review*' }) }
         else { @($item) }

$sizes = @{ 'r169' = '1200,675'; 'r11' = '1000,1000'; 'r916' = '675,1200' }
$i = 0; $done = 0; $skipped = 0

foreach ($f in $files) {
  $i++
  $png = [IO.Path]::ChangeExtension($f.FullName, '.png')
  if ((Test-Path -LiteralPath $png) -and -not $Force) { $skipped++; continue }

  # ratio from the <body class="..."> - byte-safe read, never Get-Content -Raw (cp1252 mojibake)
  $html = [IO.File]::ReadAllText($f.FullName, [Text.Encoding]::UTF8)
  $ratio = 'r169'
  foreach ($k in $sizes.Keys) { if ($html -match "<body[^>]*\b$k\b") { $ratio = $k } }
  $size = $sizes[$ratio]

  $profileDir = Join-Path ([IO.Path]::GetTempPath()) ("diagshot_" + [Guid]::NewGuid().ToString('N'))
  $uri = ([Uri]$f.FullName).AbsoluteUri

  $argline = '--headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=2 ' +
             "--window-size=$size --virtual-time-budget=$Budget --disk-cache-size=1 " +
             '--user-data-dir="' + $profileDir + '" ' +
             '--screenshot="' + $png + '" "' + $uri + '"'

  Start-Process -FilePath $browser -ArgumentList $argline -Wait -NoNewWindow
  try { Remove-Item -LiteralPath $profileDir -Recurse -Force -ErrorAction Stop } catch {}

  if (Test-Path -LiteralPath $png) {
    $kb = [math]::Round((Get-Item -LiteralPath $png).Length / 1KB)
    Write-Output ("[$i/$($files.Count)] $ratio  $($f.Name) -> $([IO.Path]::GetFileName($png))  ${kb}KB")
    $done++
  } else {
    Write-Output ("[$i/$($files.Count)] FAILED  $($f.FullName)")
  }
}
Write-Output "rendered=$done skipped=$skipped total=$($files.Count)"
if ($skipped -gt 0) { Write-Output "(skipped files already had a PNG - pass -Force to re-render them)" }
