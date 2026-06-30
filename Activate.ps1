param(
    [string]$WorkDir = ".",
    [ValidateSet("claude","pwsh","busybox")]
    [string]$Mode = "pwsh"
)

$env:PYTHONUTF8 = "1"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 > $null

# Node.js — glob 最新版 (mirrors nodevars.bat: node dir + global npm prefix)
$NodeRoot = (Get-ChildItem -Path "D:\Test" -Directory -Filter "node-v*-win-x64" | Sort-Object Name -Descending | Select-Object -First 1).FullName
if (-not $NodeRoot) { Write-Error "找不到 Node.js in D:\Test"; exit 1 }
$env:path = "$env:APPDATA\npm;$NodeRoot;" + $env:path

# LLVM toolchain — glob 最新版
$LlvmRoot = (Get-ChildItem -Path "D:\LLVM" -Directory -Filter "llvm-mingw-*-ucrt-x86_64" | Sort-Object Name -Descending | Select-Object -First 1).FullName
if (-not $LlvmRoot) { Write-Error "找不到 LLVM toolchain in D:\LLVM"; exit 1 }
$CmakeBin = (Get-ChildItem -Path "D:\Download" -Directory -Filter "cmake-*-windows-x86_64" | Sort-Object Name -Descending | Select-Object -First 1).FullName
if (-not $CmakeBin) { Write-Error "找不到 CMake in D:\Download"; exit 1 }

$env:path = "$LlvmRoot\busybox\bin;" + $env:path
$env:path = "$LlvmRoot\bin;" + $env:path
$env:path = "$CmakeBin\bin;" + $env:path

# Python venv
$venv = "D:\Test\Program\Godot\Scripts\Activate.ps1"
if (-not (Test-Path $venv)) { Write-Error "找不到 Activate.ps1 in D:\Test\Program\Godot\Scripts"; exit 1 }
. $venv

if (-not (Test-Path $WorkDir)) { Write-Error "WorkDir 不存在: $WorkDir"; exit 1 }
Set-Location -Path $WorkDir
Write-Host "Activating at $WorkDir (mode: $Mode)"
Write-Host "  Node $(node --version)  |  $(python --version 2>&1)  |  $([IO.Path]::GetFileName($LlvmRoot))"

switch ($Mode) {
    "claude"  { claude }
    "pwsh"    { }
    "busybox" {
        $initSh = (Join-Path $PSScriptRoot "Init.sh").Replace("\", "/")
        busybox.exe ash -c ". $initSh; exec ash -i"
    }
    default   { Write-Error "Unknown mode: $Mode"; exit 1 }
}
