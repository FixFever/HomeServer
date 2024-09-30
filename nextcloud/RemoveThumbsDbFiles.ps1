# script for scheduler:
# pwsh -WindowStyle hidden -file "C:\git\server\nextcloud\RemoveThumbsDbFiles.ps1"

Get-ChildItem -Path M:\nextcloud -Include Thumbs.db -Recurse -Force | Remove-Item -Force