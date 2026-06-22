@echo off
REM Weather App Icon Generator for Windows
REM This script generates all required icon sizes for Android and iOS

echo.
echo ====================================================
echo   Weather App - Icon Generator
echo ====================================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python is not installed or not in PATH
    echo.
    echo Please install Python from: https://www.python.org/downloads/
    echo Make sure to check "Add Python to PATH" during installation
    echo.
    pause
    exit /b 1
)

REM Check if required packages are installed
python -c "import cairosvg" >nul 2>&1
if errorlevel 1 (
    echo [INFO] Installing required packages...
    echo.
    pip install cairosvg pillow
    if errorlevel 1 (
        echo [ERROR] Failed to install packages
        pause
        exit /b 1
    )
)

REM Run the icon generator
echo [INFO] Generating icons...
echo.
python generate_icons.py

if errorlevel 1 (
    echo.
    echo [ERROR] Icon generation failed
    pause
    exit /b 1
) else (
    echo.
    echo [SUCCESS] Icons generated successfully!
)

pause
