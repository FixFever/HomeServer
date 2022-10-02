# HomeServer

### Hardware
* Case: [Jonsbo N1](https://www.jonsbo.com/en/products/N1.html)
  * HDD fan replaced to [Noctua NF-P14S-REDUX-900](https://noctua.at/en/nf-p14s-redux-900) 
* Motherboard: [Asrock B660M ITX/AC](https://www.asrock.com/MB/Intel/B660M-ITXac/index.ru.asp)
  * with installed [PCI-E 1x to 2 SATA ports expansion card](https://aliexpress.ru/item/1005003346314019.html)
* CPU: [Intel Core i5-12400](https://ark.intel.com/content/www/ru/ru/ark/products/134586/intel-core-i512400-processor-18m-cache-up-to-4-40-ghz.html)
* CPU cooler: [Noctua NH-L9i-17xx chromax.black](https://noctua.at/en/nh-l9i-17xx-chromax-black)
  * with installed [Noctua NA-FD1](https://noctua.at/en/na-fd1)
* RAM: 2x [8Gb DDR4 2666MHz Kingston HyperX Fury HX426C15FB/8](https://www.kingston.com/dataSheets/HX426C15FB_8.pdf)
* PSU: [be quiet! SFX POWER 3 450W](https://www.bequiet.com/ru/powersupply/2309)
* Router: [Keenetic Giga](https://keenetic.ru/ru/keenetic-giga)
  * [DDNS](https://help.keenetic.com/hc/ru/articles/360000400919-%D0%A1%D0%B5%D1%80%D0%B2%D0%B8%D1%81-%D0%B4%D0%BE%D0%BC%D0%B5%D0%BD%D0%BD%D1%8B%D1%85-%D0%B8%D0%BC%D0%B5%D0%BD-KeenDNS)
  * [VPN-сервер L2TP/IPsec](https://help.keenetic.com/hc/ru/articles/360000684919?utm_source=webhelp&utm_campaign=3.08.C.5.0-1&utm_medium=ui_notes&utm_content=controlpanel/apps.l2tp)
  * [Selective blocking bypass through Tor](https://habr.com/ru/post/428992/)
* Storages:
  * SSD: [Samsung 860 EVO 250GB](https://www.samsung.com/ru/memory-storage/sata-ssd/ssd-860-evo-sata-3-2-5-inch-250gb-mz-76e250bw/) - System
  * 1x 4TB [Seagate Barracuda ST4000DM000-1F2168](https://www.seagate.com/www-content/product-content/desktop-hdd-fam/en-us/docs/100710254f.pdf) - Plex libraries: movies, series, torrents
  * RAID 1: 2x 4TB [WD Blue WD40EZAZ-00SF3B0](https://www.westerndigital.com/ru-ru/products/internal-drives/wd-blue-desktop-sata-hdd#WD5000AZLX) - Cloud: photo, docs, etc.
  * Remote storage, FTP access by Asus RT-N66U with DDNS: 4TB [Seagate Skyhawk ST4000VX013](https://www.seagate.com/files/www-content/datasheets/pdfs/skyhawk-ai-DS1960-14C-2204RU-ru_RU.pdf) - Backups

### Software

* System: Windows 10 Pro
* [Plex](https://www.plex.tv/) with PlexPass lifetime
* [qBittorrent](https://www.qbittorrent.org/)
  * Web UI
  * [Search plugins](https://github.com/qbittorrent/search-plugins/wiki/Unofficial-search-plugins)
* [Nextcloud](https://nextcloud.com/)
* [Photoprism](https://photoprism.app/)
* [Valheim](https://www.valheimgame.com/ru/) server
* [WinSCP](https://winscp.net/eng/index.php) - for backups by FTP

In progress:
* Monitoring by Prometheus + Grafana