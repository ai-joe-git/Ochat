#!/bin/bash

# ========================================
# Ochat Complete Launcher (Enhanced)
# Starts Ollama + Web Server + Browser
# ========================================

# Color codes for better visibility
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo ""
echo "========================================"
echo "Ochat - Complete Setup"
echo "========================================"
echo ""

# ========================================
# Check if Ollama is installed
# ========================================
echo -e "${GREEN}[1/5] Checking Ollama installation...${NC}"
if ! command -v ollama &> /dev/null; then
    echo ""
    echo -e "${YELLOW}WARNING: Ollama is not installed!${NC}"
    echo ""
    echo "Ollama is required to run this application."
    echo "Would you like to download and install it now?"
    echo ""
    echo "Installation URL: https://ollama.com/download/linux"
    echo ""
    read -p "Download and install Ollama automatically? (y/n): " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        echo "Downloading and installing Ollama..."
        
        # Download and install Ollama using official installation script
        curl -fsSL https://ollama.com/install.sh | sh
        
        if [ $? -eq 0 ]; then
            echo ""
            echo "Installation complete! Verifying..."
            sleep 3
            
            # Check again after installation
            if ! command -v ollama &> /dev/null; then
                echo ""
                echo -e "${RED}ERROR: Ollama installation failed or not detected.${NC}"
                echo "Please restart this script or install manually from: https://ollama.com/download/linux"
                echo ""
                read -p "Press any key to exit..."
                exit 1
            fi
            
            echo -e "${GREEN}Ollama installed successfully!${NC}"
        else
            echo ""
            echo -e "${RED}ERROR: Failed to install Ollama.${NC}"
            echo "Please install manually from: https://ollama.com/download/linux"
            echo ""
            read -p "Press any key to exit..."
            exit 1
        fi
    else
        echo ""
        echo "Installation cancelled. Please install Ollama manually from:"
        echo "https://ollama.com/download/linux"
        echo ""
        read -p "Press any key to exit..."
        exit 1
    fi
else
    echo -e "${GREEN}Ollama is installed!${NC}"
    OLLAMA_VERSION=$(ollama --version 2>&1)
    echo "Version: $OLLAMA_VERSION"
fi

echo ""

# ========================================
# Check if Python is installed
# ========================================
echo -e "${GREEN}[2/5] Checking Python installation...${NC}"
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}ERROR: Python3 is not installed or not in PATH${NC}"
    echo "Please install Python3 using your package manager:"
    echo "  Ubuntu/Debian: sudo apt install python3"
    echo "  Fedora: sudo dnf install python3"
    echo "  Arch: sudo pacman -S python"
    echo ""
    read -p "Press any key to exit..."
    exit 1
fi

PYTHON_VERSION=$(python3 --version 2>&1)
echo "$PYTHON_VERSION detected!"
echo ""

# ========================================
# Check if ochat.html exists
# ========================================
echo -e "${GREEN}[3/5] Verifying Ochat files...${NC}"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

if [ ! -f "ochat.html" ]; then
    echo -e "${RED}ERROR: ochat.html not found in current directory${NC}"
    echo "Please make sure this script is in the same folder as ochat.html"
    echo "Current directory: $(pwd)"
    echo ""
    read -p "Press any key to exit..."
    exit 1
fi

echo -e "${GREEN}ochat.html found!${NC}"
echo ""

# ========================================
# Detect local IP address
# ========================================
echo -e "${GREEN}[4/5] Detecting network configuration...${NC}"

# Try multiple methods to detect local IP
if command -v ip &> /dev/null; then
    LOCAL_IP=$(ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1' | head -n1)
elif command -v hostname &> /dev/null; then
    LOCAL_IP=$(hostname -I | awk '{print $1}')
else
    LOCAL_IP=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | head -n1)
fi

if [ -z "$LOCAL_IP" ]; then
    LOCAL_IP="YOUR_IP_ADDRESS_HERE"
    echo -e "${YELLOW}WARNING: Could not auto-detect IP. Check manually with: ip addr or ifconfig${NC}"
else
    echo "Local IP detected: $LOCAL_IP"
fi

echo ""

# ========================================
# Configure and start Ollama
# ========================================
echo -e "${GREEN}[5/5] Starting services...${NC}"
echo ""

# Check if Ollama is already running
if pgrep -x "ollama" > /dev/null; then
    echo "Ollama is already running. Restarting for fresh configuration..."
    pkill -9 ollama
    sleep 2
fi

# Configure Ollama environment variables for network access
echo "Configuring Ollama for network access..."
export OLLAMA_HOST=0.0.0.0:11434
export OLLAMA_ORIGINS="*"

# Start Ollama in background
echo "Starting Ollama server..."
ollama serve > /dev/null 2>&1 &
OLLAMA_PID=$!

# Wait for Ollama to start with better feedback
echo "Initializing Ollama (this may take a few seconds)..."
RETRY_COUNT=0
MAX_RETRIES=10

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    sleep 1
    if curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
        echo -e "${GREEN}Ollama server is ready!${NC}"
        break
    fi
    RETRY_COUNT=$((RETRY_COUNT + 1))
    echo "Still waiting... ($RETRY_COUNT/$MAX_RETRIES)"
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    echo ""
    echo -e "${YELLOW}WARNING: Ollama may not have started correctly${NC}"
    echo "Continuing anyway, but you may experience connection issues."
    echo ""
fi

echo ""
echo "========================================"
echo "Starting Ochat Web Server"
echo "========================================"
echo ""
echo "Server will be available at:"
echo "  Desktop: http://localhost:5500/ochat.html"
echo "  Mobile:  http://$LOCAL_IP:5500/ochat.html"
echo ""
echo "Ollama API accessible at:"
echo "  Desktop: http://localhost:11434"
echo "  Mobile:  http://$LOCAL_IP:11434"
echo ""
echo "IMPORTANT FOR MOBILE:"
echo "  1. Connect to same WiFi network"
echo "  2. Open Ochat Settings"
echo "  3. Set Ollama Host URL to: http://$LOCAL_IP:11434"
echo ""
echo "Press Ctrl+C to stop all servers"
echo ""
echo "Quick Access:"
echo "Copy this URL to your mobile browser:"
echo "  http://$LOCAL_IP:5500/ochat.html"
echo ""

# Wait before opening browser
sleep 2

# Open browser to Ochat (cross-platform)
if command -v xdg-open &> /dev/null; then
    xdg-open http://localhost:5500/ochat.html &> /dev/null &
elif command -v gnome-open &> /dev/null; then
    gnome-open http://localhost:5500/ochat.html &> /dev/null &
elif command -v open &> /dev/null; then
    open http://localhost:5500/ochat.html &> /dev/null &
fi

# Cleanup function to stop services on exit
cleanup() {
    echo ""
    echo "========================================"
    echo "Shutting Down Servers"
    echo "========================================"
    echo ""
    echo "Stopping Ollama server..."
    kill $OLLAMA_PID 2>/dev/null
    pkill -9 ollama 2>/dev/null
    echo "Stopping Python server..."
    pkill -f "python3 -m http.server 5500" 2>/dev/null
    sleep 1
    echo ""
    echo "All services stopped. Goodbye!"
    echo ""
    exit 0
}

# Trap Ctrl+C and call cleanup
trap cleanup SIGINT SIGTERM

# Start Python HTTP server (this will block until Ctrl+C)
python3 -m http.server 5500

# If we get here, cleanup
cleanup
