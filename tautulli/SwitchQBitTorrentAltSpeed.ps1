$pause = [bool]::Parse($args[0])

if ($pause) {
	qbt global limit alternative --set true --username $Env:QBITTORRENT_USER --password $Env:QBITTORRENT_PASSWORD --url http://localhost:8080/
    # qbt torrent pause all --username $Env:QBITTORRENT_USER --password $Env:QBITTORRENT_PASSWORD --url http://localhost:8080/
} else {
	qbt global limit alternative --set false --username $Env:QBITTORRENT_USER --password $Env:QBITTORRENT_PASSWORD --url http://localhost:8080/
    # qbt torrent resume all --username $Env:QBITTORRENT_USER --password $Env:QBITTORRENT_PASSWORD --url http://localhost:8080/
}