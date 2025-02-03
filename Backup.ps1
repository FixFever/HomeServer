# script for scheduler:
# pwsh -file "C:\git\server\Backup.ps1"

param(
	[switch]$SkipZip = $false
)

if (!$SkipZip){
	
	# Zip docker volumes
	try{
		$containers = docker ps -q
		foreach ($container in $containers) {
			docker pause $container
		}
		
		Get-ChildItem -Path \\wsl$\docker-desktop\mnt\docker-desktop-disk\data\docker\volumes -Directory | Foreach-Object { docker run --rm -v "${_}:/data" -v "H:\backups\docker-volumes:/docker-volumes" ubuntu tar cvzf "/docker-volumes/${_}.tar.gz" /data }
	}
	catch {
		Write-Host $_
		Invoke-WebRequest -URI ($Env:TELEGRAM_REPORT_URL + "Create zip volumes failed: " + $_)
		return;
	}
	finally{
		foreach ($container in $containers) {
			docker unpause $container
		}
	}

	# Zip qbittorrent data
	try{
		Copy-Item -Path "$env:LOCALAPPDATA\qBittorrent" -Destination "H:\backups\appdata-local-qbittorrent" -Recurse -Force
		Copy-Item -Path "$env:APPDATA\qBittorrent" -Destination "H:\backups\appdata-roaming-qbittorrent" -Recurse -Force
		
		Compress-Archive -LiteralPath "H:\backups\appdata-local-qbittorrent" -DestinationPath "H:\backups\appdata-local-qbittorrent.zip" -Force
		Compress-Archive -LiteralPath "H:\backups\appdata-roaming-qbittorrent" -DestinationPath "H:\backups\appdata-roaming-qbittorrent.zip" -Force
	}
	catch {
		Write-Host $_
		Invoke-WebRequest -URI ($Env:TELEGRAM_REPORT_URL + "Create zip qbittorrent data failed: " + $_)
		return;
	}
	finally{
		Remove-Item -Path H:\backups\appdata-local-qbittorrent -Recurse -Force
		Remove-Item -Path H:\backups\appdata-roaming-qbittorrent -Recurse -Force
	}

	# Export plex options
	regedit /e "H:\backups\plex_settings.reg" "HKEY_CURRENT_USER\Software\Plex, Inc.\Plex Media Server"

	# Zip plex data
	try{
		Copy-Item -Path "$env:LOCALAPPDATA\Plex Media Server" -Destination "H:\backups\appdata-local-plex-media-server" -Recurse -Force
		Compress-Archive -LiteralPath "H:\backups\appdata-local-plex-media-server" -DestinationPath "H:\backups\appdata-local-plex-media-server.zip" -Force
	}
	catch {
		Write-Host $_
		Invoke-WebRequest -URI ($Env:TELEGRAM_REPORT_URL + "Create zip plex data failed: " + $_)
		return;
	}
	finally{
		Remove-Item -Path H:\backups\appdata-local-plex-media-server -Recurse -Force
	}

	# Zip tautulli data
	try{
		Copy-Item -Path "$env:LOCALAPPDATA\Tautulli" -Destination "H:\backups\appdata-local-tautulli" -Recurse -Force
		Compress-Archive -LiteralPath "H:\backups\appdata-local-tautulli" -DestinationPath "H:\backups\appdata-local-tautulli.zip" -Force
	}
	catch {
		Write-Host $_
		Invoke-WebRequest -URI ($Env:TELEGRAM_REPORT_URL + "Create zip tautulli failed: " + $_)
		return;
	}
	finally{
		Remove-Item -Path H:\backups\appdata-local-tautulli -Recurse -Force
	}

	# Zip documents
	try{
		Copy-Item -Path "C:\Users\FixFever\Documents" -Destination "H:\backups\Documents" -Recurse -Force
		Compress-Archive -LiteralPath "H:\backups\Documents" -DestinationPath "H:\backups\Documents.zip" -Force
	}
	catch {
		Write-Host $_
		Invoke-WebRequest -URI ($Env:TELEGRAM_REPORT_URL + "Create zip documents failed: " + $_)
		return;
	}
	finally{
		Remove-Item -Path H:\backups\Documents -Recurse -Force
	}
}

# Download keenetic running-config
try{
	wsl sshpass -p "$Env:KEENETIC_PASSWORD" ssh $Env:KEENETIC_LOGIN@192.168.1.1 -p $Env:KEENETIC_PORT 'show running-config' > "H:\backups\keenetic_running_config"
}
catch {
    Write-Host $_
	Invoke-WebRequest -URI ($Env:TELEGRAM_REPORT_URL + "Backup keenetic config failed: " + $_)
	return;
}

# Export env vars
regedit /e "H:\backups\env_vars.reg" "HKEY_CURRENT_USER\Environment"

$logsPath = "%TEMP%";

# Upload to storage
$logs = $logsPath + "/WinSCP_" + (Get-Date).ToString("yyyyMMdd_HHmmss") + ".log";
	
$winscpResult;

for($i=1;$i -le 5;$i++)
{
	winscp /log=$logs /ini=nul `
	    /command `
		"open davs://${Env:WEBDAV_USER}:${Env:WEBDAV_PASSWORD}@${Env:WEBDAV_HOST}/webdav/Backup -rawsettings ProxyPort=0" `
		"synchronize remote M:\\nextcloud nextcloud -delete -criteria=size" `
		"synchronize remote H:\\backups backups -delete -criteria=size" `
		"synchronize remote H:\\docker-volumes\\prometheus prometheus -delete -criteria=size" `
	    "exit"
	
	$winscpResult = $LastExitCode
	if ($winscpResult -eq 0)
	{
		break;
	}
	else
	{
		Invoke-WebRequest -URI ($Env:TELEGRAM_REPORT_URL + "Backup failed, attempt "+ $i + ". See " + $logs)
	}
}

if ($winscpResult -eq 0)
{
	Write-Host "Success"
	Invoke-WebRequest -URI ($Env:TELEGRAM_REPORT_URL + "Backup completed successfully")
	break;
}
else
{
	Write-Host "Error"
	Invoke-WebRequest -URI ($Env:TELEGRAM_REPORT_URL + "Backup failed after "+ $i +" attempts. See " + $logs)
}