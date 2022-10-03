# script for scheduler:
# powershell -file "C:\git\server\Backup.ps1"

try{
	
	docker-compose stop
	
	Compress-Archive -LiteralPath "C:\docker-volumes" -DestinationPath "C:\Users\FixFever\Documents\docker-volumes.zip"
	
	docker-compose up -d
	
	$logs = "C:\Users\FixFever\Documents\WinSCP.log";
	
    winscp /log=$logs /ini=nul `
        /command `
    "open ftp://${Env:FTP_USER}:${Env:FTP_PASSWORD}@${Env:FTP_HOST}/ -rawsettings ProxyPort=0" `
	    "synchronize remote M:\\nextcloud Backup/Backup/nextcloud -delete -criteria=size" `
		"synchronize remote C:\Users\FixFever\Documents\ValheimBackups Backup/Backup/valheim/backup -delete -criteria=size" `
		"put C:\Users\FixFever\Documents\docker-volumes.zip Backup/Backup/ -delete" `
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