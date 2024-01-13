# script for scheduler:
# powershell -file "C:\git\server\MinecraftBackup.ps1"

try{
	
docker-compose stop minecraft
Compress-Archive -LiteralPath "C:\docker-volumes\minecraft" -DestinationPath "H:\minecraft_backups\$(Get-Date -Format 'MMddyyyyHHmm').zip"
Get-ChildItem -Recurse -Path "H:\minecraft_backups" | Where-Object -Property CreationTime -lt (Get-Date).AddDays(-30) | Remove-Item

}
finally{
	docker-compose up minecraft -d
}