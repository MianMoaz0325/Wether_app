#!/usr/bin/env python3
"""
Weather App Icon Generator
Generates all required icon sizes for Android and iOS from SVG source
"""

import os
import sys
from pathlib import Path

def generate_icons():
    """
    Generate icons in all required sizes.
    Requires: pip install cairosvg pillow
    """
    try:
        import cairosvg
        from PIL import Image
        import io
    except ImportError:
        print("❌ Required packages not installed!")
        print("\nTo install required packages, run:")
        print("  pip install cairosvg pillow")
        print("\nOr for macOS:")
        print("  brew install cairo")
        print("  pip install cairosvg pillow")
        return False

    # Define icon sizes for different platforms
    ICON_SIZES = {
        # Android sizes
        'android/app/src/main/res/mipmap-mdpi/ic_launcher.png': 48,
        'android/app/src/main/res/mipmap-hdpi/ic_launcher.png': 72,
        'android/app/src/main/res/mipmap-xhdpi/ic_launcher.png': 96,
        'android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png': 144,
        'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png': 192,
        
        # iOS sizes
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@1x.png': 20,
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png': 40,
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png': 60,
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1x.png': 29,
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png': 58,
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3x.png': 87,
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@1x.png': 40,
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png': 80,
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png': 120,
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png': 120,
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png': 180,
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1x.png': 76,
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png': 152,
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png': 167,
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png': 1024,
    }

    svg_path = Path('app_icon.svg')
    
    if not svg_path.exists():
        print(f"❌ SVG file not found: {svg_path}")
        return False

    success_count = 0
    error_count = 0

    print("🎨 Generating app icons...\n")

    for output_path, size in ICON_SIZES.items():
        try:
            output_file = Path(output_path)
            output_file.parent.mkdir(parents=True, exist_ok=True)

            # Convert SVG to PNG
            png_buffer = io.BytesIO()
            cairosvg.svg2png(
                url=str(svg_path),
                write_to=png_buffer,
                output_width=size,
                output_height=size
            )
            png_buffer.seek(0)

            # Save PNG
            with open(output_file, 'wb') as f:
                f.write(png_buffer.getvalue())

            print(f"✓ Generated {output_path} ({size}x{size})")
            success_count += 1

        except Exception as e:
            print(f"✗ Failed to generate {output_path}: {str(e)}")
            error_count += 1

    print(f"\n{'='*60}")
    print(f"✓ Successfully generated: {success_count} icons")
    if error_count > 0:
        print(f"✗ Failed: {error_count} icons")
    print(f"{'='*60}")

    return error_count == 0


if __name__ == '__main__':
    print("🌤  Weather App Icon Generator\n")
    success = generate_icons()
    sys.exit(0 if success else 1)
