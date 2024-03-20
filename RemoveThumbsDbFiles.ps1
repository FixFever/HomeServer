# script for scheduler:
# powershell -WindowStyle hidden -file "C:\git\server\RemoveThumbsDbFiles.ps1" -WindowStyle Hidden

Get-ChildItem -Path M:\nextcloud -Include Thumbs.db -Recurse -Force | Remove-Item -Force