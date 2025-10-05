REM add link to %appdata%\Microsoft\Windows\Start Menu\Programs\Startup

REM Send notify to telegram
pwsh -command `Invoke-WebRequest -URI ($Env:TELEGRAM_REPORT_URL + \"Server is up\");`

REM USB CO2 meter attach to WSL
REM https://github.com/dorssel/usbipd-win/issues/798
REM Wait until wsl started
TIMEOUT 180
:check_wsl
wsl --list >nul 2>&1
if %errorlevel% neq 0 (
    timeout /t 1 >nul
    goto check_wsl
)
usbipd attach --wsl --busid 1-6
