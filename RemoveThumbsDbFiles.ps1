# script for scheduler:
# powershell -file "C:\git\server\RemoveThumbsDbFiles.ps1"

Get-ChildItem -Path M:\nextcloud -Include Thumbs.db -Recurse -Force | Remove-Item -Force