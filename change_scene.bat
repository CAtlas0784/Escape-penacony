@echo off
setlocal enabledelayedexpansion
title Escape Penacony Tool - ppSR Scene Selector
chcp 65001 > nul
cd /d "%~dp0"

:: Check PowerShell availability
set "PS_EXEC=powershell.exe"
where pwsh.exe >nul 2>&1 && set "PS_EXEC=pwsh.exe"

:: Check if script exists
if not exist "%~dp0ppsr_teleport.ps1" (
    echo [X] Error: ppsr_teleport.ps1 not found in: %~dp0
    pause
    exit /b 1
)

:: Run interactive selector
"%PS_EXEC%" -NoProfile -ExecutionPolicy Bypass -File "%~dp0ppsr_teleport.ps1" %*

if %errorlevel% neq 0 (
    echo.
    echo [!] Program exited with code %errorlevel%
    pause
)
