# script for scheduler:
# powershell -file "C:\git\server\ValheimBackup.ps1"

Compress-Archive -LiteralPath "C:\Users\FixFever\AppData\LocalLow\IronGate\Valheim" -DestinationPath "C:\Users\FixFever\Documents\ValheimBackups\$(Get-Date -Format 'MMddyyyyHHmm').zip"
Get-ChildItem -Recurse -Path "C:\Users\FixFever\Documents\ValheimBackups" | Where-Object -Property CreationTime -lt (Get-Date).AddDays(-30) | Remove-Item