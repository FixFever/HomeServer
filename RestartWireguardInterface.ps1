# script for scheduler:
# powershell -file "C:\git\server\RestartWireguardInterface.ps1"

$wireguardState = wsl sshpass -p "$Env:KEENETIC_PASSWORD" ssh $Env:KEENETIC_LOGIN@192.168.1.1 -p $Env:KEENETIC_PORT 'show interface Wireguard0'

if ($wireguardState -like "*state: down*") {
	Write-Host "Wireguard state is down"
	return;
}

if ($wireguardState -like "*link: up*") {
    Write-Host "Wireguard is up"
	return;
}	

Invoke-WebRequest -URI ($Env:TELEGRAM_REPORT_URL + "Wireguard is down. Trying to restart...")
  
wsl sshpass -p "$Env:KEENETIC_PASSWORD" ssh $Env:KEENETIC_LOGIN@192.168.1.1 -p $Env:KEENETIC_PORT 'interface Wireguard0 down'
wsl sshpass -p "$Env:KEENETIC_PASSWORD" ssh $Env:KEENETIC_LOGIN@192.168.1.1 -p $Env:KEENETIC_PORT 'interface Wireguard0 up'
  
  
for($i=1; $i -le 12; $i++){
	Write-Host "Sleep 10 sec"
	Start-Sleep -Seconds 10
	$newState = wsl sshpass -p "$Env:KEENETIC_PASSWORD" ssh $Env:KEENETIC_LOGIN@192.168.1.1 -p $Env:KEENETIC_PORT 'show interface Wireguard0'
	if ($newState -like "*link: up*") { 
		Invoke-WebRequest -URI ($Env:TELEGRAM_REPORT_URL + "Wireguard is up")
		return;
	}
}

Invoke-WebRequest -URI ($Env:TELEGRAM_REPORT_URL + "Wireguard still down. Set state to disabled.")
wsl sshpass -p "$Env:KEENETIC_PASSWORD" ssh $Env:KEENETIC_LOGIN@192.168.1.1 -p $Env:KEENETIC_PORT 'interface Wireguard0 down'


# Выключено
             # link: down
        # connected: no
            # state: down

# Включено, работает
             # link: up
        # connected: yes
            # state: up
			
# Включено, но не работает
             # link: down
        # connected: no
            # state: up
			