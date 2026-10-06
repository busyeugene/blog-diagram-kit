<#
  find-browser.ps1 - locate a Chromium browser for headless screenshots.
  Dot-sourced by render.ps1 and review.ps1. KEEP THIS FILE PURE ASCII.

  Order: $env:DIAGRAM_BROWSER, then Edge, then Chrome, then Chromium, on Windows / macOS / Linux.
#>
function Find-Browser {
  $candidates = @()
  if ($env:DIAGRAM_BROWSER) { $candidates += $env:DIAGRAM_BROWSER }
  $candidates += @(
    "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
    "C:\Program Files\Microsoft\Edge\Application\msedge.exe",
    "C:\Program Files\Google\Chrome\Application\chrome.exe",
    "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe",
    "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge",
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
    "/Applications/Chromium.app/Contents/MacOS/Chromium",
    "/usr/bin/microsoft-edge",
    "/usr/bin/google-chrome",
    "/usr/bin/chromium",
    "/usr/bin/chromium-browser"
  )
  if ($env:LOCALAPPDATA) {
    $candidates += (Join-Path $env:LOCALAPPDATA "Google\Chrome\Application\chrome.exe")
  }
  foreach ($c in $candidates) {
    if ($c -and (Test-Path -LiteralPath $c)) { return $c }
  }
  throw "No Edge/Chrome/Chromium found. Install one, or set DIAGRAM_BROWSER to the browser executable."
}
