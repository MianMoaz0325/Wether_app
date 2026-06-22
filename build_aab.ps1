# Build signed AAB for Play Store
# Weather App - Android App Bundle Builder

param(
    [switch]$SkipKeystore = $false,
    [string]$KeystorePassword,
    [string]$KeyPassword
)

Write-Host ""
Write-Host "=================================="
Write-Host "  Weather App - AAB Builder"
Write-Host "=================================="
Write-Host ""

# Check if keystore exists
$keystorePath = "weather_release.keystore"
$keyPropertiesPath = "android/key.properties"

if (Test-Path $keystorePath) {
    Write-Host "✓ Keystore found: $keystorePath" -ForegroundColor Green
}
else {
    Write-Host "✗ Keystore not found. Creating new one..." -ForegroundColor Yellow
    
    if (!$KeystorePassword) {
        $KeystorePassword = Read-Host "Enter keystore password"
    }
    if (!$KeyPassword) {
        $KeyPassword = $KeystorePassword
    }
    
    # Generate keystore
    Write-Host "Generating keystore file..." -ForegroundColor Cyan
    keytool -genkey -v -keystore $keystorePath `
        -keyalg RSA -keysize 2048 -validity 10000 `
        -alias weather_key `
        -dname "CN=Ahmad,OU=Weather App,O=Ahmad Weather,L=Lahore,ST=Punjab,C=PK" `
        -storepass $KeystorePassword `
        -keypass $KeyPassword
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Keystore created successfully" -ForegroundColor Green
    }
    else {
        Write-Host "✗ Failed to create keystore" -ForegroundColor Red
        exit 1
    }
}

# Create key.properties if it doesn't exist
if (!(Test-Path $keyPropertiesPath)) {
    Write-Host "Creating key.properties file..." -ForegroundColor Cyan
    
    if (!$KeystorePassword) {
        $KeystorePassword = Read-Host "Enter keystore password"
    }
    if (!$KeyPassword) {
        $KeyPassword = $KeystorePassword
    }
    
    $keyPropertiesContent = @"
storePassword=$KeystorePassword
keyPassword=$KeyPassword
keyAlias=weather_key
storeFile=../weather_release.keystore
"@
    
    Set-Content -Path $keyPropertiesPath -Value $keyPropertiesContent
    Write-Host "✓ key.properties created" -ForegroundColor Green
}
else {
    Write-Host "✓ key.properties found" -ForegroundColor Green
}

# Clean, get dependencies, and build
Write-Host ""
Write-Host "Building signed AAB..." -ForegroundColor Cyan
Write-Host ""

# Flutter clean
Write-Host "1/3: Cleaning build artifacts..." -ForegroundColor Yellow
flutter clean
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Flutter clean failed" -ForegroundColor Red
    exit 1
}

# Flutter pub get
Write-Host "2/3: Getting dependencies..." -ForegroundColor Yellow
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Flutter pub get failed" -ForegroundColor Red
    exit 1
}

# Flutter build appbundle
Write-Host "3/3: Building App Bundle..." -ForegroundColor Yellow
flutter build appbundle --release
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Flutter build appbundle failed" -ForegroundColor Red
    exit 1
}

# Verify output
Write-Host ""
$aabPath = "build/app/outputs/bundle/release/app-release.aab"
if (Test-Path $aabPath) {
    $aabSize = (Get-Item $aabPath).Length / 1MB
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "✓ BUILD SUCCESSFUL!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "AAB File Location:" -ForegroundColor Cyan
    Write-Host "  $(Resolve-Path $aabPath)" -ForegroundColor White
    Write-Host ""
    Write-Host "File Size: $([Math]::Round($aabSize, 2)) MB" -ForegroundColor White
    Write-Host ""
    Write-Host "Next Steps:" -ForegroundColor Cyan
    Write-Host "  1. Go to: https://play.google.com/console" -ForegroundColor White
    Write-Host "  2. Select your app (Weather App)" -ForegroundColor White
    Write-Host "  3. Click 'Release' → 'Production'" -ForegroundColor White
    Write-Host "  4. Click 'Create new release'" -ForegroundColor White
    Write-Host "  5. Upload the AAB file above" -ForegroundColor White
    Write-Host "  6. Review and publish" -ForegroundColor White
    Write-Host ""
    Write-Host "⚠️  IMPORTANT:" -ForegroundColor Yellow
    Write-Host "  - BACKUP your keystore file: $keystorePath" -ForegroundColor Yellow
    Write-Host "  - BACKUP your key.properties file" -ForegroundColor Yellow
    Write-Host "  - You'll need these for future app updates!" -ForegroundColor Yellow
    Write-Host ""
}
else {
    Write-Host "✗ AAB file not created" -ForegroundColor Red
    exit 1
}

Write-Host "========================================" -ForegroundColor Green
