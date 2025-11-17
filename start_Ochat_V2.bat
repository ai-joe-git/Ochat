@echo off
setlocal enabledelayedexpansion

REM ========================================
REM Ochat Complete Launcher (Enhanced)
REM Starts Ollama + Web Server + Browser
REM ========================================

REM Set console colors for better visibility
color 0A

echo.
echo ========================================
echo    Ochat - Complete Setup
echo ========================================
echo.

REM ========================================
REM Check if Ollama is installed
REM ========================================
echo [1/5] Checking Ollama installation...
ollama --version >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo WARNING: Ollama is not installed!
    echo.
    echo Ollama is required to run this application.
    echo Would you like to download and install it now?
    echo.
    echo Download URL: https://ollama.com/download/OllamaSetup.exe
    echo.
    choice /C YN /M "Download and install Ollama automatically"
    
    if !errorlevel! equ 1 (
        echo.
        echo Downloading Ollama installer...
        
        REM Download Ollama installer using PowerShell
        powershell -Command "& {$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri 'https://ollama.com/download/OllamaSetup.exe' -OutFile '%TEMP%\OllamaSetup.exe'}"
        
        if exist "%TEMP%\OllamaSetup.exe" (
            echo.
            echo Running Ollama installer...
            echo Please follow the installation wizard.
            echo.
            start /wait "" "%TEMP%\OllamaSetup.exe"
            
            REM Clean up installer
            del "%TEMP%\OllamaSetup.exe" >nul 2>&1
            
            echo.
            echo Installation complete! Verifying...
            timeout /t 3 /nobreak >nul
            
            REM Check again after installation
            ollama --version >nul 2>&1
            if !errorlevel! neq 0 (
                echo.
                echo ERROR: Ollama installation failed or not detected.
                echo Please restart this script or install manually from: https://ollama.com/download
                echo.
                pause
                exit /b 1
            )
            
            echo Ollama installed successfully!
        ) else (
            echo.
            echo ERROR: Failed to download Ollama installer.
            echo Please install manually from: https://ollama.com/download
            echo.
            pause
            exit /b 1
        )
    ) else (
        echo.
        echo Installation cancelled. Please install Ollama manually from:
        echo https://ollama.com/download
        echo.
        pause
        exit /b 1
    )
) else (
    echo Ollama is installed!
    for /f "tokens=*" %%a in ('ollama --version 2^>^&1') do echo Version: %%a
)

echo.

REM ========================================
REM Check if Python is installed
REM ========================================
echo [2/5] Checking Python installation...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python from https://www.python.org/downloads/
    echo.
    pause
    exit /b 1
)
for /f "tokens=*" %%a in ('python --version 2^>^&1') do echo %%a detected!

echo.

REM ========================================
REM Check if ochat.html exists
REM ========================================
echo [3/5] Verifying Ochat files...
set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

if not exist "ochat.html" (
    echo ERROR: ochat.html not found in current directory
    echo Please make sure this batch file is in the same folder as ochat.html
    echo Current directory: %CD%
    echo.
    pause
    exit /b 1
)
echo ochat.html found!

echo.

REM ========================================
REM Detect local IP address
REM ========================================
echo [4/5] Detecting network configuration...
for /f "delims=" %%a in ('powershell -Command "(Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias 'Wi-Fi','Ethernet','Ethernet 2','Wi-Fi 2' -ErrorAction SilentlyContinue | Where-Object {$_.IPAddress -like '192.168.*' -or $_.IPAddress -like '10.*' -or $_.IPAddress -like '172.*'} | Select-Object -First 1).IPAddress"') do set LOCAL_IP=%%a

REM Fallback if PowerShell method fails
if not defined LOCAL_IP (
    for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /C:"IPv4 Address" ^| findstr /V "127.0.0.1"') do (
        set "LOCAL_IP=%%a"
        goto :ip_found
    )
)

:ip_found
set LOCAL_IP=%LOCAL_IP: =%

if not defined LOCAL_IP (
    set LOCAL_IP=YOUR_IP_ADDRESS_HERE
    echo WARNING: Could not auto-detect IP. Check manually with: ipconfig
) else (
    echo Local IP detected: %LOCAL_IP%
)

echo.

REM ========================================
REM Configure and start Ollama
REM ========================================
echo [5/5] Starting services...
echo.

REM Check if Ollama is already running
tasklist /FI "IMAGENAME eq ollama.exe" 2>NUL | find /I /N "ollama.exe">NUL
if %errorlevel% equ 0 (
    echo Ollama is already running. Restarting for fresh configuration...
    taskkill /F /IM ollama.exe >nul 2>&1
    timeout /t 2 /nobreak >nul
)

REM Configure Ollama environment variables for network access
echo Configuring Ollama for network access...
set OLLAMA_HOST=0.0.0.0:11434
set OLLAMA_ORIGINS=*
set $env:OLLAMA_VULKAN="1"

REM Start Ollama in background
echo Starting Ollama server...
start "Ollama Server" /MIN cmd /c "ollama serve"

REM Wait for Ollama to start with better feedback
echo Initializing Ollama (this may take a few seconds)...
set RETRY_COUNT=0
:wait_ollama
timeout /t 1 /nobreak >nul
curl -s http://localhost:11434/api/tags >nul 2>&1
if %errorlevel% neq 0 (
    set /a RETRY_COUNT+=1
    if !RETRY_COUNT! lss 10 (
        echo Still waiting... (!RETRY_COUNT!/10)
        goto :wait_ollama
    ) else (
        echo.
        echo WARNING: Ollama may not have started correctly
        echo Continuing anyway, but you may experience connection issues.
        echo.
    )
) else (
    echo Ollama server is ready!
)

echo.
echo ========================================
echo    Starting Ochat Web Server
echo ========================================
echo.
echo Server will be available at:
echo   Desktop: http://localhost:5500/ochat.html
echo   Mobile:  http://%LOCAL_IP%:5500/ochat.html
echo.
echo Ollama API accessible at:
echo   Desktop: http://localhost:11434
echo   Mobile:  http://%LOCAL_IP%:11434
echo.
echo IMPORTANT FOR MOBILE:
echo   1. Connect to same WiFi network
echo   2. Open Ochat Settings
echo   3. Set Ollama Host URL to: http://%LOCAL_IP%:11434
echo.
echo Press Ctrl+C to stop all servers
echo.

REM Generate QR code URL for mobile (optional enhancement)
echo Quick Access:
echo   Copy this URL to your mobile browser:
echo   http://%LOCAL_IP%:5500/ochat.html
echo.

REM Wait before opening browser
timeout /t 2 /nobreak >nul

REM Open browser to Ochat
start http://localhost:5500/ochat.html

REM Start Python HTTP server (this will block until Ctrl+C)
python -m http.server 5500

REM This part only runs after Ctrl+C is pressed
echo.
echo ========================================
echo    Shutting Down Servers
echo ========================================
echo.
echo Stopping Ollama server...
taskkill /F /IM ollama.exe >nul 2>&1
echo Stopping Python server...
timeout /t 1 /nobreak >nul
echo.
echo All services stopped. Goodbye!
echo.
pause
