@echo off
where gcc > nul 2>&1
if %errorlevel% equ 0 (
    echo MinGW is installed.
) else (
    echo MinGW is not installed.
    exit 1
)
