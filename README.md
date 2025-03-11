# HomeServer

### Hardware
* Case: [Jonsbo N1](https://www.jonsbo.com/en/products/N1.html)
  * HDD fan replaced to [be quiet! SILENT WINGS 4 140mm PWM high-speed](https://www.bequiet.com/ru/casefans/3704)
  * Addional fan [Noctua NF-A4X20 PWM](https://noctua.at/en/nf-a4x20-pwm)
* Motherboard: [Asrock B660M ITX/AC](https://www.asrock.com/MB/Intel/B660M-ITXac/index.ru.asp)
  * with installed [PCI-E 1x to 2 SATA ports expansion card](https://aliexpress.ru/item/1005003346314019.html)
* CPU: [Intel Core i5-12400](https://ark.intel.com/content/www/ru/ru/ark/products/134586/intel-core-i512400-processor-18m-cache-up-to-4-40-ghz.html)
* CPU cooler: [Noctua NH-L9i-17xx chromax.black](https://noctua.at/en/nh-l9i-17xx-chromax-black)
  * with installed [Noctua NA-FD1](https://noctua.at/en/na-fd1)
* RAM: 2x [16Gb DDR4 3200MHz Kingston Fury Beast KF432C16BBK2/32](https://www.kingston.com/dataSheets/KF432C16BBK2_32.pdf)
* PSU: [be quiet! SFX POWER 3 450W](https://www.bequiet.com/ru/powersupply/2309)
* Storages:
  * NVMe M.2 SSD: [Samsung 970 EVO Plus 500GB](https://www.samsung.com/ru/memory-storage/nvme-ssd/970-evo-plus-500gb-mz-v7s500bw/) - System
    * with installed Сoolleo CL-M.2 HR-10 radiator
  * 1x 16TB [Seagate Exos X18 ST16000NM000J](https://www.seagate.com/content/dam/seagate/migrated-assets/www-content/datasheets/pdfs/exos-x18-channel-DS2045-4-2106US-en_US.pdf) - Plex libraries: movies, series, torrents
  * RAID 1: 2x 4TB [WD Blue WD40EZAZ-00SF3B0](https://www.westerndigital.com/ru-ru/products/internal-drives/wd-blue-desktop-sata-hdd#WD5000AZLX) - Cloud: photo, docs, etc.
  * 1х 1TB [Seagate Barracuda 7200.12](https://www.seagate.com/docs/pdf/ru-RU/datasheet/disc/barracuda-7200-12-ds1668-6-1101ru.pdf) - backups, prometheus data
* Router: [Keenetic Ultra KN-1811](https://keenetic.ru/ru/keenetic-ultra-kn-1811)
  * [OPKG Entware](https://help.keenetic.com/hc/ru/articles/360000948719-OPKG)
  * [Bird4Static](https://github.com/DennoN-RUS/Bird4Static) - selective blocking bypass through Amnezia VPN
  * [IPset4Static](https://github.com/DennoN-RUS/IPset4Static) - selective blocking bypass through Amnezia VPN
  * [Web4Static](https://github.com/spatiumstas/web4static) - web interface for managing Bird4Static lists
  * [DDNS](https://help.keenetic.com/hc/ru/articles/360000400919-%D0%A1%D0%B5%D1%80%D0%B2%D0%B8%D1%81-%D0%B4%D0%BE%D0%BC%D0%B5%D0%BD%D0%BD%D1%8B%D1%85-%D0%B8%D0%BC%D0%B5%D0%BD-KeenDNS)
  * [AdguardHome](https://github.com/DennoN-RUS/IPset4Static/wiki/AdguardHome)
* IP-Camera: [TP-Link Tapo C225](https://www.tp-link.com/ru/home-networking/cloud-camera/tapo-c225/)
* UPS: [CyberPower CP1300EPFCLCD](https://www.cyberpower.com/ru/ru/product/sku/cp1300epfclcd)
* CO2-meter: [ZyAura ZGm053U](https://www.zyaura.com/product-detail/zgm053u/)

### Software

* System: Windows 10 Pro
* [Plex](https://www.plex.tv/) with PlexPass lifetime -  streaming media service
* [Tautulli](https://github.com/Tautulli/Tautulli) - monitoring, analytics and notifications for Plex
* [qBittorrent](https://www.qbittorrent.org/) - bittorrent client
* [Windows reporter](https://github.com/prometheus-community/windows_exporter) - a Prometheus exporter for Windows machines
* [Glances](https://github.com/nicolargo/glances) - system monitoring tool
* [WinSCP](https://winscp.net/eng/index.php) - FTP, FTPS, SCP, SFTP, WebDAV client for Windows
* Docker Desktop
  * [Caddy-gen](https://github.com/wemake-services/caddy-gen) - reverse proxy
  * [Watchtower](https://github.com/containrrr/watchtower) - a process for automating Docker container base image updates
  * [Homepage](https://github.com/gethomepage/homepage) - application dashboard
  * [Nextcloud](https://nextcloud.com/) - file storage
    * [Preview generator](https://github.com/nextcloud/previewgenerator)
    * [Memories](https://github.com/pulsejet/memories)
  * [Photoprism](https://photoprism.app/) - AI-Powered Photos App
  * [Home assistant](https://www.home-assistant.io/) - Home automation service
    * [Home Assistant Community Store](https://www.hacs.xyz/)
  * [Valheim](https://github.com/lloesche/valheim-server-docker) server
  * [Burn-after-reading](https://github.com/Tethik/burn-after-reading) - share short term messages stored in memory
  * [Vaultwarden](https://github.com/dani-garcia/vaultwarden) - password management
  * [Gokapi](https://github.com/Forceu/Gokapi) - share files
  * [Shinobi](https://www.shinobi.video/) - NVR and CCTV
  * [Chromium with NoVNC](https://github.com/vital987/chrome-novnc) - Chrome in browser
  * [Standard notes server](https://github.com/standardnotes/server) + [web app](https://github.com/standardnotes/app) - note-taking app
  * [Cobalt](https://github.com/imputnet/cobalt) - media downloader
  * [LibreSpeed](https://github.com/librespeed/speedtest) - speedtest
  * [IT-Tools](https://github.com/CorentinTh/it-tools) - useful tools for developer and people working in IT
  * [R2-HTML-DB](https://github.com/Aksel911/R2-HTML-DB) - R2 online wiki
  * [Prometheus](https://github.com/prometheus/prometheus) - monitoring
  * [Grafana](https://github.com/grafana/grafana) - data visualization & Monitoring
  * [Air-co2-exporter](https://github.com/huhamhire/air-co2-exporter) - Prometheus exporter for CO2 meter
  * [TorrUpd](https://github.com/konkere/TorrUpd) - tool for automatically checking the relevance of torrents and updating them in the torrent client

### Remote backup storage
* Router: [Keenetic Giga KN-1010](https://keenetic.ru/ru/keenetic-giga-kn-1010)
  * WebDAV server
  * [DDNS](https://help.keenetic.com/hc/ru/articles/360000400919-%D0%A1%D0%B5%D1%80%D0%B2%D0%B8%D1%81-%D0%B4%D0%BE%D0%BC%D0%B5%D0%BD%D0%BD%D1%8B%D1%85-%D0%B8%D0%BC%D0%B5%D0%BD-KeenDNS)
* Storages:
  * 4TB [Seagate Skyhawk ST4000VX013](https://www.seagate.com/files/www-content/datasheets/pdfs/skyhawk-ai-DS1960-14C-2204RU-ru_RU.pdf)
  
### VPS
* VPS in NL by [VDSka](https://vdska.ru/)
* [Amnezia VPN](https://amnezia.org/)