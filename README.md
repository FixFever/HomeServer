# HomeServer

### Hardware
* Case: [Jonsbo N1](https://www.jonsbo.com/en/products/N1.html)
  * HDD fan replaced to [Noctua NF-P14S-REDUX-900](https://noctua.at/en/nf-p14s-redux-900) 
* Motherboard: [Asrock B660M ITX/AC](https://www.asrock.com/MB/Intel/B660M-ITXac/index.ru.asp)
  * with installed [PCI-E 1x to 2 SATA ports expansion card](https://aliexpress.ru/item/1005003346314019.html)
* CPU: [Intel Core i5-12400](https://ark.intel.com/content/www/ru/ru/ark/products/134586/intel-core-i512400-processor-18m-cache-up-to-4-40-ghz.html)
* CPU cooler: [Noctua NH-L9i-17xx chromax.black](https://noctua.at/en/nh-l9i-17xx-chromax-black)
  * with installed [Noctua NA-FD1](https://noctua.at/en/na-fd1)
* RAM: 2x [16Gb DDR4 3200MHz Kingston Fury Beast KF432C16BBK2/32](https://www.kingston.com/dataSheets/KF432C16BBK2_32.pdf)
* PSU: [be quiet! SFX POWER 3 450W](https://www.bequiet.com/ru/powersupply/2309)
* Router: [Keenetic Giga](https://keenetic.ru/ru/keenetic-giga)
  * [DDNS](https://help.keenetic.com/hc/ru/articles/360000400919-%D0%A1%D0%B5%D1%80%D0%B2%D0%B8%D1%81-%D0%B4%D0%BE%D0%BC%D0%B5%D0%BD%D0%BD%D1%8B%D1%85-%D0%B8%D0%BC%D0%B5%D0%BD-KeenDNS)
  * Selective blocking bypass through WireGuard VPN using [Bird4Static](https://github.com/DennoN-RUS/Bird4Static)
* Storages:
  * NVMe M.2 SSD: [Samsung 970 EVO Plus 500GB](https://www.samsung.com/ru/memory-storage/nvme-ssd/970-evo-plus-500gb-mz-v7s500bw/) - System
  * 1x 16TB [Seagate Exos X18 ST16000NM000J](https://www.seagate.com/content/dam/seagate/migrated-assets/www-content/datasheets/pdfs/exos-x18-channel-DS2045-4-2106US-en_US.pdf) - Plex libraries: movies, series, torrents
  * RAID 1: 2x 4TB [WD Blue WD40EZAZ-00SF3B0](https://www.westerndigital.com/ru-ru/products/internal-drives/wd-blue-desktop-sata-hdd#WD5000AZLX) - Cloud: photo, docs, etc.

### Software

* System: Windows 10 Pro
* [Plex](https://www.plex.tv/) with PlexPass lifetime
* [qBittorrent](https://www.qbittorrent.org/)
  * Web UI by [qbit-matUI](https://github.com/bill-ahmed/qbit-matUI)
* [Nextcloud](https://nextcloud.com/)
* [Photoprism](https://photoprism.app/)
* [Valheim](https://github.com/lloesche/valheim-server-docker) server
* [WinSCP](https://winscp.net/eng/index.php) - for backups by FTP
* [QuakeJS](https://github.com/treyyoder/quakejs-docker) server
* [burn-after-reading](https://github.com/Tethik/burn-after-reading) service
* Monitoring 
  * [Prometheus](https://github.com/prometheus/prometheus)
    * [Windows reporter](https://github.com/prometheus-community/windows_exporter)
  * [Grafana](https://github.com/grafana/grafana)
  
### Remote backup storage
* Router: Asus RT-N66U
  * DDNS
  * FTP
* Storages:
  * 4TB [Seagate Skyhawk ST4000VX013](https://www.seagate.com/files/www-content/datasheets/pdfs/skyhawk-ai-DS1960-14C-2204RU-ru_RU.pdf)
  
### VPS
* VPS in Amsterdam by [Virmach](https://virmach.com/)
* [WireGuard](https://www.wireguard.com/) VPN server (installer by [angristan](https://github.com/angristan/wireguard-install))