@echo off
REM Build Signed Android App Bundle (AAB) for Play Store
REM Weather App - Build Script

setlocal enabledelayedexpansion

echo.
echo ====================================================
echo   Weather App - AAB Builder
echo ====================================================
echo.

REM Check if keystore exists
if not exist "weather_release.keystore" (
    echo.
    echo [WARNING] Keystore file not found!
    echo.
    echo Please run this command first to create a keystore:
    echo.
    echo   keytool -genkey -v -keystore weather_release.keystore ^
    echo     -keyalg RSA -keysize 2048 -validity 10000 -alias weather_key
    echo.
    echo This is a ONE-TIME setup. After that, you can run this script again.
    echo.
    pause
    exit /b 1
) else (
    echo [OK] Keystore found: weather_release.keystore
)

REM Check if key.properties exists
if not exist "android\key.properties" (
    echo.
    echo [WARNING] key.properties not found!
    echo.
    echo Create file: android\key.properties
    echo With content:
    echo.
    echo   storePassword=YOUR_PASSWORD
    echo   keyPassword=YOUR_PASSWORD
    echo   keyAlias=weather_key
    echo   storeFile=../weather_release.keystore
    echo.
    echo Replace YOUR_PASSWORD with your keystore password.
    echo.
    pause
    exit /b 1
) else (
    echo [OK] key.properties found
)

REM Clean
echo.
echo [1/3] Cleaning build artifacts...
call flutter clean
if errorlevel 1 (
    echo [ERROR] Flutter clean failed
    pause
    exit /b 1
)

REM Get dependencies
echo.
echo [2/3] Getting dependencies...
call flutter pub get
if errorlevel 1 (
    echo [ERROR] Flutter pub get failed
    pause
    exit /b 1
)

REM Build AAB
echo.
echo [3/3] Building Android App Bundle...
echo.
call flutter build appbundle --release
if errorlevel 1 (
    echo [ERROR] Flutter build appbundle failed
    pause
    exit /b 1
)

REM Verify
echo.
if exist "build\app\outputs\bundle\release\app-release.aab" (
    echo.
    echo ====================================================
    echo   BUILD SUCCESSFUL!
    echo ====================================================
    echo.
    echo AAB File Location:
    echo   %CD%\build\app\outputs\bundle\release\app-release.aab
    echo.
    echo File Size:
    for /F "tokens=*" %%A in ('powershell -Command "[math]::Round((Get-Item \"build\app\outputs\bundle\release\app-release.aab\").Length / 1MB, 2)"') do echo   %%A MB
    echo.
    echo Next Steps:
    echo   1. Go to: https://play.google.com/console
    echo   2. Select: Weather App
    echo   3. Click: Release ^> Production
    echo   4. Click: Create new release
    echo   5. Upload the AAB file above
    echo   6. Review and Publish
    echo.
    echo WARNING:
    echo   - BACKUP your keystore file: weather_release.keystore
    echo   - BACKUP your key.properties file
    echo   - You'll need these for future updates!
    echo.
    echo ====================================================
) else (
    echo.
    echo [ERROR] AAB file not created!
    echo.
)

pause
