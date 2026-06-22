# 🎨 Weather App Icon Generation Guide

## Overview
This guide explains how to generate all required app icons for both Android and iOS platforms from the SVG source file.

## Quick Start (Windows)

Simply run the batch file:
```bash
generate_icons.bat
```

The script will:
1. Check if Python is installed
2. Install required packages (cairosvg, pillow)
3. Generate all icons in the correct sizes and locations

## Manual Setup (macOS/Linux)

### 1. Install Required Packages

**macOS:**
```bash
# Install cairo (required by cairosvg)
brew install cairo

# Install Python packages
pip install cairosvg pillow
```

**Linux (Ubuntu/Debian):**
```bash
# Install dependencies
sudo apt-get install libcairo2-dev pkg-config python3-dev

# Install Python packages
pip install cairosvg pillow
```

**Windows:**
```bash
# Install Python packages
pip install cairosvg pillow
```

### 2. Generate Icons

Run the Python script:
```bash
python generate_icons.py
```

## Generated Icon Sizes

### Android Icons
| Size | Resolution | Location |
|------|-----------|----------|
| MDPI | 48x48 | `android/app/src/main/res/mipmap-mdpi/ic_launcher.png` |
| HDPI | 72x72 | `android/app/src/main/res/mipmap-hdpi/ic_launcher.png` |
| XHDPI | 96x96 | `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png` |
| XXHDPI | 144x144 | `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png` |
| XXXHDPI | 192x192 | `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png` |

### iOS Icons
| Size | Resolution | Location |
|------|-----------|----------|
| 20pt @1x | 20x20 | `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@1x.png` |
| 20pt @2x | 40x40 | `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png` |
| 20pt @3x | 60x60 | `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png` |
| 29pt @1x | 29x29 | `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1x.png` |
| 29pt @2x | 58x58 | `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png` |
| 29pt @3x | 87x87 | `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3x.png` |
| 40pt @1x | 40x40 | `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@1x.png` |
| 40pt @2x | 80x80 | `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png` |
| 40pt @3x | 120x120 | `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png` |
| 60pt @2x | 120x120 | `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png` |
| 60pt @3x | 180x180 | `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png` |
| 76pt @1x | 76x76 | `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1x.png` |
| 76pt @2x | 152x152 | `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png` |
| 83.5pt @2x | 167x167 | `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png` |
| App Store | 1024x1024 | `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png` |

## Icon Design Features

The generated icon includes:
- ☀️ **Bright Sun** - Represents clear weather
- ☁️ **White Cloud** - Represents cloudy conditions  
- 🌧️ **Rain Drops** - Represents precipitation
- 🎨 **Sky Blue Gradient** - Professional weather app appearance

## Alternative Methods

### Using Online Tools

If you encounter issues with Python/cairosvg, you can use online SVG to PNG converters:

1. Go to [CloudConvert](https://cloudconvert.com/svg-to-png) or [Zamzar](https://www.zamzar.com/convert/svg-to-png/)
2. Upload `app_icon.svg`
3. Download each required size individually
4. Place in the respective folders

### Using Figma

1. Import `app_icon.svg` into [Figma](https://www.figma.com/)
2. Export each required size from Figma
3. Place in the respective folders

### Using Adobe XD or Illustrator

1. Open `app_icon.svg` in Adobe XD or Illustrator
2. Export artboards for each size
3. Place in the respective folders

## Troubleshooting

### cairosvg installation fails

**On macOS:**
```bash
# Try using Homebrew Python
brew install python3
/usr/local/bin/python3 -m pip install cairosvg pillow
```

**On Linux:**
```bash
# Install development headers
sudo apt-get install libcairo2-dev libpango-1.0-0 libpango-cairo-1.0-0 libpango-1.0-dev
pip install cairosvg pillow
```

### Icons not showing up in app

1. Clean build directories:
   ```bash
   flutter clean
   ```

2. Rebuild the app:
   ```bash
   flutter pub get
   flutter run
   ```

3. For Android, sometimes the old icons are cached:
   ```bash
   cd android && ./gradlew clean && cd ..
   ```

### Permission denied on generate_icons.sh

Make the script executable:
```bash
chmod +x generate_icons.sh
./generate_icons.sh
```

## Manual Icon Placement (If Automation Fails)

If the script doesn't work, you can manually place the generated icons:

1. Generate icons from SVG using an online tool
2. Rename them according to the sizes listed above
3. Place them in their respective directories as shown in the tables above

## Customizing the Icon

To customize the icon design:

1. Edit `app_icon.svg` with any SVG editor (Inkscape, Adobe XD, Figma, etc.)
2. Run the generation script again to update all sizes

Key elements in the SVG:
- `<linearGradient id="skyGradient">` - Sky background gradient
- `<g id="sun">` - Sun element
- `<g id="cloud">` - Cloud element  
- `<g id="rain">` - Rain drops element

## Platform-Specific Notes

### Android
- Icons are automatically scaled for different screen densities
- The main icon is `ic_launcher.png` in each dpi folder
- Both adaptive and legacy icons are supported

### iOS
- Icons must be exactly the specified size (no scaling by Apple)
- Transparency is supported
- The largest icon (1024x1024) is used for App Store display

## Verification

After generation, verify:

1. ✓ All required icon files are created
2. ✓ File sizes are reasonable (not too small)
3. ✓ App runs without icon warnings
4. ✓ Icons display correctly on devices

## Next Steps

After generating icons:

1. Test the app:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. Check the app icon displays correctly on home screen

3. Build for release:
   ```bash
   flutter build apk    # Android
   flutter build ipa    # iOS
   ```

## Support

If you encounter issues:
1. Check the troubleshooting section above
2. Ensure Python 3.6+ is installed
3. Try the alternative methods listed
4. Check the generated icons are valid PNG files

---

**Generated:** Weather App Icon Generation System
**SVG Source:** `app_icon.svg`
**Last Updated:** April 22, 2026
