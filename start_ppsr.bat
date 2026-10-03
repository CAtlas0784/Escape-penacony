@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul
set PYTHONIOENCODING=utf-8
title ppSR Server (Port 21000 / 23301)

set "PPSR_EXE="

:: 1. Check relative to script directory
if exist "%~dp0ppsr.exe" set "PPSR_EXE=%~dp0ppsr.exe"
if not defined PPSR_EXE (
    if exist "%~dp0..\ppsr.exe" set "PPSR_EXE=%~dp0..\ppsr.exe"
)

:: 2. Check saved persistent_path in ppsr_config.json
if not defined PPSR_EXE (
    if exist "%~dp0ppsr_config.json" (
        for /f "tokens=2 delims=:, " %%A in ('findstr /i "persistent_path" "%~dp0ppsr_config.json"') do (
            set "SAVED_PATH=%%~A"
            set "SAVED_PATH=!SAVED_PATH:\misc\persistent.json=\ppsr.exe!"
            set "SAVED_PATH=!SAVED_PATH:\persistent.json=\ppsr.exe!"
            if exist "!SAVED_PATH!" set "PPSR_EXE=!SAVED_PATH!"
        )
    )
)

:: 3. Dynamic scan across user Downloads & Desktop without any hardcoded username
if not defined PPSR_EXE (
    for /d %%D in ("%USERPROFILE%\Downloads\ppSR*" "%USERPROFILE%\Desktop\ppSR*") do (
        if exist "%%~fD\ppsr.exe" set "PPSR_EXE=%%~fD\ppsr.exe"
        if exist "%%~fD\ppSR*\ppsr.exe" set "PPSR_EXE=%%~fD\ppSR*\ppsr.exe"
    )
)

:: 4. Fallback search inside Downloads
if not defined PPSR_EXE (
    for /f "delims=" %%F in ('where /r "%USERPROFILE%\Downloads" ppsr.exe 2^>nul') do (
        set "PPSR_EXE=%%F"
        goto :launch
    )
)

:launch
if not defined PPSR_EXE (
    echo [X] Could not locate ppsr.exe automatically!
    echo Please drag and drop your ppsr.exe file or ppSR folder into this window:
    set /p "USER_INPUT=Path: "
    set "USER_INPUT=!USER_INPUT:"=!"
    if exist "!USER_INPUT!\ppsr.exe" set "PPSR_EXE=!USER_INPUT!\ppsr.exe"
    if exist "!USER_INPUT!" set "PPSR_EXE=!USER_INPUT!"
)

if not defined PPSR_EXE (
    echo [X] Invalid path. Exiting...
    pause
    exit /b 1
)

:: Terminate any lingering ppsr instances to avoid port conflicts
taskkill /F /IM ppsr.exe >nul 2>&1

echo [*] Starting ppSR Server in UTF-8 mode: "!PPSR_EXE!"
for %%I in ("!PPSR_EXE!") do cd /d "%%~dpI"
"!PPSR_EXE!"

if !errorlevel! neq 0 (
    echo.
    echo [!] ppSR server closed with error code !errorlevel!
    pause
)
