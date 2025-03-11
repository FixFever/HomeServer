REM add link to %appdata%\Microsoft\Windows\Start Menu\Programs\Startup

REM USB CO2 meter attach to WSL
REM https://github.com/dorssel/usbipd-win/issues/798
usbipd attach --wsl --busid 1-6

REM Send notify to telegram
pwsh -command `Invoke-WebRequest -URI ($Env:TELEGRAM_REPORT_URL + \"Server is up\");`;