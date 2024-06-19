# pwsh.exe -WindowStyle hidden C:\git\server\plex\StartPlexIfNotRunning.ps1

$Prog = "C:\Program Files (x86)\Plex\Plex Media Server\Plex Media Server.exe"
if (! (ps | ? {$_.path -eq $prog})) {& $prog}