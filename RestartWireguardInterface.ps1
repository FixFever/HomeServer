# script for scheduler:
# powershell -file "C:\git\server\RestartWireguardInterface.ps1"

wsl sshpass -p "$Env:KEENETIC_PASSWORD" ssh $Env:KEENETIC_LOGIN@192.168.1.1 -p $Env:KEENETIC_PORT 'interface Wireguard0 down'
wsl sshpass -p "$Env:KEENETIC_PASSWORD" ssh $Env:KEENETIC_LOGIN@192.168.1.1 -p $Env:KEENETIC_PORT 'interface Wireguard0 up'