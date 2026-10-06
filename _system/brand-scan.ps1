<#
  brand-scan.ps1 - point it at your homepage and it reports the raw material for a brand.css:
  font families, Google Fonts imports, and hex colours ranked by how often the site actually uses them.

  Usage:
    .\_system\brand-scan.ps1 -Url "https://www.yoursite.com/"
    .\_system\brand-scan.ps1 -Url "https://example.com/" -Top 30

  This is a STARTING POINT, not the answer. Frequency finds the palette; it cannot tell you which
  colour is the brand's primary versus a grey used in a footer. Always eyeball the site afterwards
  and sanity-check the picks - see _system/ONBOARDING.md.

  KEEP THIS FILE PURE ASCII. Windows PowerShell 5.1 reads a UTF-8-without-BOM .ps1 as cp1252, so a
  single em dash or curly quote breaks the PARSE, not just the output.
#>
param(
  [Parameter(Mandatory=$true)][string]$Url,
  [int]$Top = 24,
  [int]$MaxSheets = 12
)

$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

function Get-Text([string]$u) {
  try { return (Invoke-WebRequest -Uri $u -UseBasicParsing -TimeoutSec 25).Content }
  catch { Write-Output "  ! could not fetch $u"; return "" }
}

Write-Output "Scanning $Url"
$html = Get-Text $Url
if (-not $html) { throw "No HTML returned - check the URL." }

$base = [Uri]$Url
$css  = ""

# inline <style> blocks
foreach ($m in [regex]::Matches($html, '(?is)<style[^>]*>(.*?)</style>')) { $css += "`n" + $m.Groups[1].Value }

# external stylesheets
$hrefs = @()
foreach ($m in [regex]::Matches($html, '(?is)<link[^>]+rel\s*=\s*["'']?stylesheet["'']?[^>]*>')) {
  $tag = $m.Value
  $h = [regex]::Match($tag, '(?is)href\s*=\s*["'']([^"'']+)["'']')
  if ($h.Success) { $hrefs += $h.Groups[1].Value }
}
$hrefs = $hrefs | Select-Object -Unique | Select-Object -First $MaxSheets

Write-Output ""
Write-Output "Stylesheets found: $($hrefs.Count)"
foreach ($h in $hrefs) {
  $abs = try { ([Uri]::new($base, $h)).AbsoluteUri } catch { $h }
  Write-Output "  - $abs"
  if ($abs -match 'fonts\.googleapis\.com') { continue }   # keep the import line, skip the payload
  $css += "`n" + (Get-Text $abs)
}

# ---------- Google Fonts ----------
Write-Output ""
Write-Output "== GOOGLE FONTS IMPORTS =="
$gf = @()
foreach ($m in [regex]::Matches($html + $css, '(?i)fonts\.googleapis\.com/css2?\?[^"''\)\s]+')) { $gf += $m.Value }
if ($gf.Count) { $gf | Select-Object -Unique | ForEach-Object { Write-Output "  $_" } }
else { Write-Output "  (none - the site may self-host its fonts; check @font-face src URLs)" }

# ---------- font families ----------
Write-Output ""
Write-Output "== FONT FAMILIES (by declaration count) =="
$fam = @{}
foreach ($m in [regex]::Matches($css, '(?i)font-family\s*:\s*([^;}]+)')) {
  $first = ($m.Groups[1].Value -split ',')[0].Trim().Trim('"').Trim("'")
  if ($first -and $first -notmatch '^(inherit|initial|unset|var\()' ) {
    if ($fam.ContainsKey($first)) { $fam[$first]++ } else { $fam[$first] = 1 }
  }
}
$fam.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 12 |
  ForEach-Object { "{0,5}x  {1}" -f $_.Value, $_.Key } | Write-Output

# ---------- @font-face families (self-hosted) ----------
$ff = [regex]::Matches($css, '(?is)@font-face\s*\{[^}]*font-family\s*:\s*["'']?([^;"''}]+)')
if ($ff.Count) {
  Write-Output ""
  Write-Output "== SELF-HOSTED @font-face =="
  $ff | ForEach-Object { "  " + $_.Groups[1].Value.Trim() } | Select-Object -Unique | Write-Output
}

# ---------- colours ----------
Write-Output ""
Write-Output "== HEX COLOURS (by use count) =="
$col = @{}
foreach ($m in [regex]::Matches($css, '#([0-9a-fA-F]{6}|[0-9a-fA-F]{3})\b')) {
  $h = $m.Groups[1].Value.ToLower()
  if ($h.Length -eq 3) { $h = "$($h[0])$($h[0])$($h[1])$($h[1])$($h[2])$($h[2])" }
  $h = "#$h"
  if ($col.ContainsKey($h)) { $col[$h]++ } else { $col[$h] = 1 }
}
# neutrals are noise when you are hunting for a brand colour - flag them rather than hide them
function Is-Neutral([string]$hex) {
  $r=[Convert]::ToInt32($hex.Substring(1,2),16); $g=[Convert]::ToInt32($hex.Substring(3,2),16); $b=[Convert]::ToInt32($hex.Substring(5,2),16)
  $max=[Math]::Max($r,[Math]::Max($g,$b)); $min=[Math]::Min($r,[Math]::Min($g,$b))
  return (($max - $min) -le 18)
}
$col.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First $Top | ForEach-Object {
  $tag = if (Is-Neutral $_.Key) { "neutral" } else { "COLOUR " }
  "{0,5}x  {1}  {2}" -f $_.Value, $_.Key, $tag
} | Write-Output

Write-Output ""
Write-Output "Next: copy _system/brand-template.css to <Brand>/brand.css and fill it in."
Write-Output "Then follow _system/ONBOARDING.md - the frequency ranking is a lead, not a verdict."
