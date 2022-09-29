try{
	
	# # # docker exec -u 33 nextcloud /var/www/html/occ maintenance:mode --on
	docker-compose stop
	
	Compress-Archive -LiteralPath "C:\docker-volumes" -DestinationPath "C:\docker-volumes.zip"
	
	# # # docker exec -u 33 nextcloud /var/www/html/occ maintenance:mode --off
	docker-compose up -d
	
    winscp /log="C:\Users\FixFever\Documents\WinSCP.log" /ini=nul `
        /command `
    "open ftp://${Env:FTP_USER}:${Env:FTP_PASSWORD}@${Env:FTP_HOST}/ -rawsettings ProxyPort=0" `
	    "synchronize remote M:\\nextcloud Backup/Backup/nextcloud -delete -criteria=size" `
		"synchronize remote C:\Users\FixFever\Documents\ValheimBackups Backup/Backup/valheim/backup -delete -criteria=size" `
		"put C:\docker-volumes.zip Backup/Backup/ -delete" `
        "exit"

    $winscpResult = $LastExitCode
    if ($winscpResult -eq 0)
    {
        Write-Host "Success"
    }
    else
    {
        Write-Host "Error"
    }

    exit $winscpResult
}
catch {
    Write-Host $_
}
finally{
	
}