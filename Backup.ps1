# script for scheduler:
# powershell -file "C:\git\server\Backup.ps1"

skipZip = false;

if (!skipZip){
	
# Zip docker volumes
try{
	
	docker-compose stop
	
	Compress-Archive -LiteralPath "C:\docker-volumes" -DestinationPath "C:\backups\docker-volumes.zip" -Force
}
catch {
    Write-Host $_
	Invoke-WebRequest -URI ($Env:TELEGRAM_REPORT_URL + "Create zip volumes failed: " + $_)
	return;
}
finally{
	docker-compose up -d
}

# Zip qbittorrent data
try{
	Copy-Item -Path "$env:LOCALAPPDATA\qBittorrent" -Destination "C:\backups\appdata-local-qbittorrent" -Recurse -Force
	Copy-Item -Path "$env:APPDATA\qBittorrent" -Destination "C:\backups\appdata-roaming-qbittorrent" -Recurse -Force
	
	Compress-Archive -LiteralPath "C:\backups\appdata-local-qbittorrent" -DestinationPath "C:\backups\appdata-local-qbittorrent.zip" -Force
	Compress-Archive -LiteralPath "C:\backups\appdata-roaming-qbittorrent" -DestinationPath "C:\backups\appdata-roaming-qbittorrent.zip" -Force
}
catch {
    Write-Host $_
	Invoke-WebRequest -URI ($Env:TELEGRAM_REPORT_URL + "Create zip qbittorrent data failed: " + $_)
	return;
}
finally{
	Remove-Item -Path C:\backups\appdata-local-qbittorrent -Recurse -Force
	Remove-Item -Path C:\backups\appdata-roaming-qbittorrent -Recurse -Force
}

# Export plex options
regedit /e "C:\backups\plex_settings.reg" "HKEY_CURRENT_USER\Software\Plex, Inc.\Plex Media Server"

# Zip plex data
try{
	Copy-Item -Path "$env:LOCALAPPDATA\Plex Media Server" -Destination "C:\backups\appdata-local-plex-media-server" -Recurse -Force
	Compress-Archive -LiteralPath "C:\backups\appdata-local-plex-media-server" -DestinationPath "C:\backups\appdata-local-plex-media-server.zip" -Force
}
catch {
    Write-Host $_
	Invoke-WebRequest -URI ($Env:TELEGRAM_REPORT_URL + "Create zip plex data failed: " + $_)
	return;
}
finally{
	Remove-Item -Path C:\backups\appdata-local-plex-media-server -Recurse -Force
}

# Download keenetic running-config
try{
	wsl sshpass -p "$Env:KEENETIC_PASSWORD" ssh "$Env:KEENETIC_LOGIN@192.168.1.1" 'show running-config' > "C:\backups\keenetic_running_config"
}
catch {
    Write-Host $_
	Invoke-WebRequest -URI ($Env:TELEGRAM_REPORT_URL + "Backup keenetic config failed: " + $_)
	return;
}

}

# Export env vars
regedit /e "C:\backups\env_vars.reg" "HKEY_CURRENT_USER\Environment"

# Upload to storage
try{	
	$logs = "C:\Users\FixFever\Documents\WinSCP.log";
	
    winscp /log=$logs /ini=nul `
        /command `
    "open ftp://${Env:FTP_USER}:${Env:FTP_PASSWORD}@${Env:FTP_HOST}/ -rawsettings ProxyPort=0" `
	    "synchronize remote M:\\nextcloud Backup/Backup/nextcloud -delete -criteria=size" `
		"synchronize remote C:\\backups Backup/Backup/backups -delete -criteria=size" `
        "exit"

    $winscpResult = $LastExitCode
    if ($winscpResult -eq 0)
    {
        Write-Host "Success"
		Invoke-WebRequest -URI ($Env:TELEGRAM_REPORT_URL + "Backup completed successfully")
    }
    else
    {
        Write-Host "Error"
		Invoke-WebRequest -URI ($Env:TELEGRAM_REPORT_URL + "Backup failed. See " + $logs)
    }

    exit $winscpResult
}
catch {
    Write-Host $_
	Invoke-WebRequest -URI ($Env:TELEGRAM_REPORT_URL + "Backup failed: " + $_)
}
finally{

}