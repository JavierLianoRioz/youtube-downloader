@echo off
SETLOCAL
SET PowerShellPath=powershell.exe

REM Verificar si PowerShell está instalado
where %PowerShellPath% >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo PowerShell no está instalado.
    pause
    exit /b 1
)

REM Ejecutar el script principal
%PowerShellPath% -ExecutionPolicy Bypass -NoProfile -File "%~dp0main.ps1"

ENDLOCAL
