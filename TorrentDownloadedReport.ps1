# script for qbittorrent:
# pwsh -file "C:\git\server\TorrentDownloadedReport.ps1" "%N"

Invoke-WebRequest -URI ($Env:TELEGRAM_REPORT_URL + $args[0] + " downloaded");