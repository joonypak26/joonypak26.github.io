# C:\Users\user organize script
# Run: powershell -ExecutionPolicy Bypass -File organize_user_folders.ps1

$desktop = "C:\Users\user\Desktop"
$downloads = "C:\Users\user\Downloads"
$userRoot = "C:\Users\user"

# 1. Desktop - WorkDocs, WebShortcuts
New-Item -Path "$desktop\WorkDocs" -ItemType Directory -Force | Out-Null
New-Item -Path "$desktop\WebShortcuts" -ItemType Directory -Force | Out-Null

$workFiles = @(
    "2025년 서울지하철 파업 관련 상황실 근무명단(교통실).hwpx",
    "국장님 식사순번.hwpx",
    "행정망 장애 모의훈련.hwpx"
)
foreach ($f in $workFiles) {
    $p = Join-Path $desktop $f
    if (Test-Path $p) { Move-Item -LiteralPath $p -Destination "$desktop\WorkDocs\" -Force }
}
$hwp = Get-ChildItem -Path $desktop -Filter "주간일정*.hwp" -File -ErrorAction SilentlyContinue | Select-Object -First 1
if ($hwp) { Move-Item -LiteralPath $hwp.FullName -Destination "$desktop\WorkDocs\" -Force }

Get-ChildItem -Path $desktop -Filter "*.url" -File | Move-Item -Destination "$desktop\WebShortcuts\" -Force -ErrorAction SilentlyContinue

# 2. Downloads - PDF, Excel
New-Item -Path "$downloads\PDF" -ItemType Directory -Force | Out-Null
New-Item -Path "$downloads\Excel" -ItemType Directory -Force | Out-Null

Get-ChildItem -Path $downloads -Filter "*.pdf" -File | Move-Item -Destination "$downloads\PDF\" -Force -ErrorAction SilentlyContinue
Get-ChildItem -Path $downloads -Filter "*.xlsx" -File | Move-Item -Destination "$downloads\Excel\" -Force -ErrorAction SilentlyContinue

# 3. User root - Installers, Logs
New-Item -Path "$userRoot\Installers" -ItemType Directory -Force | Out-Null
New-Item -Path "$userRoot\Logs" -ItemType Directory -Force | Out-Null

foreach ($exe in @("SeoulCity_EPPSetup.exe", "tgatedist.exe")) {
    $p = Join-Path $userRoot $exe
    if (Test-Path $p) { Move-Item -Path $p -Destination "$userRoot\Installers\" -Force }
}
$ini = Join-Path $userRoot "Foxit Reader SDK ActiveX.ini"
if (Test-Path $ini) { Move-Item -Path $ini -Destination "$userRoot\Installers\" -Force }
$log = Join-Path $userRoot "KCase.log"
if (Test-Path $log) { Move-Item -Path $log -Destination "$userRoot\Logs\" -Force }

Write-Host "Done. Desktop: WorkDocs, WebShortcuts. Downloads: PDF, Excel. User: Installers, Logs."
