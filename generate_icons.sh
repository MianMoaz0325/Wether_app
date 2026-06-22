#!/bin/bash
# Weather App Icon Generator for macOS/Linux
# This script generates all required icon sizes for Android and iOS

echo ""
echo "===================================================="
echo "  Weather App - Icon Generator"
echo "===================================================="
echo ""

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macOS"
    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        echo "[ERROR] Homebrew is not installed"
        echo ""
        echo "Install Homebrew from: https://brew.sh/"
        exit 1
    fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="Linux"
else
    echo "[ERROR] Unsupported operating system"
    exit 1
fi

echo "[INFO] Detected OS: $OS"
echo ""

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "[ERROR] Python 3 is not installed"
    echo ""
    if [[ "$OS" == "macOS" ]]; then
        echo "Install Python with: brew install python3"
    else
        echo "Install Python with: sudo apt-get install python3 python3-pip"
    fi
    exit 1
fi

PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
echo "[INFO] Python version: $PYTHON_VERSION"
echo ""

# Check if required packages are installed
echo "[INFO] Checking required packages..."

python3 -c "import cairosvg" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "[INFO] Installing required packages..."
    echo ""
    
    if [[ "$OS" == "macOS" ]]; then
        echo "  Installing cairo..."
        brew install cairo
        if [ $? -ne 0 ]; then
            echo "[ERROR] Failed to install cairo"
            exit 1
        fi
    elif [[ "$OS" == "Linux" ]]; then
        echo "  Installing development headers..."
        sudo apt-get update
        sudo apt-get install -y libcairo2-dev pkg-config python3-dev libpango-1.0-0 libpango-cairo-1.0-0
        if [ $? -ne 0 ]; then
            echo "[ERROR] Failed to install dependencies"
            exit 1
        fi
    fi
    
    echo ""
    echo "  Installing Python packages..."
    pip3 install cairosvg pillow
    if [ $? -ne 0 ]; then
        echo "[ERROR] Failed to install Python packages"
        echo ""
        echo "Try installing with: pip3 install --upgrade cairosvg pillow"
        exit 1
    fi
fi

echo "[INFO] All dependencies are installed"
echo ""

# Run the icon generator
echo "[INFO] Generating icons..."
echo ""

python3 generate_icons.py
RESULT=$?

echo ""

if [ $RESULT -ne 0 ]; then
    echo "[ERROR] Icon generation failed"
    exit 1
else
    echo "[SUCCESS] Icons generated successfully!"
    echo ""
    echo "Next steps:"
    echo "  1. flutter clean"
    echo "  2. flutter pub get"
    echo "  3. flutter run"
    echo ""
fi

exit 0
