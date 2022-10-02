REM add link to C:\Users\FixFever\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
powershell -command `Invoke-WebRequest -URI ($Env:TELEGRAM_REPORT_URL + \"Server is up\");`;