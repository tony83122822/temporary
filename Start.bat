@echo off
setlocal
rem Launcher only. All env setup lives in Activate.ps1 (single source of truth).
rem Keep this .bat pure ASCII -- cmd.exe reads .bat with the OEM codepage,
rem so UTF-8/Chinese here corrupts parsing.
set "UTIL=%~dp0"
set "WORK=%CD%"

rem Detect Windows Terminal; fallback to plain powershell
where wt >nul 2>&1
if %errorlevel% equ 0 (
    set "OPEN=wt new-tab powershell -NoExit -File"
) else (
    set "OPEN=powershell -NoExit -File"
)

cls
echo ==========================
echo VibeCoding Launcher
echo ==========================
echo [1] Claude (venv + toolchain)
echo [2] PowerShell shell (venv + toolchain)
echo [3] BusyBox ash shell (venv + toolchain)
echo [Q] Quit
echo.
choice /C 123Q /N /M "Select an option: "
rem choice returns 1/2/3/4 errorlevel is ">=", so test high to low
if errorlevel 4 goto end
if errorlevel 3 goto busybox
if errorlevel 2 goto pwsh
if errorlevel 1 goto claude

:claude
%OPEN% "%UTIL%Activate.ps1" -WorkDir "%WORK%" -Mode claude
goto end

:pwsh
%OPEN% "%UTIL%Activate.ps1" -WorkDir "%WORK%" -Mode pwsh
goto end

:busybox
%OPEN% "%UTIL%Activate.ps1" -WorkDir "%WORK%" -Mode busybox
goto end

:end
endlocal
exit /b
