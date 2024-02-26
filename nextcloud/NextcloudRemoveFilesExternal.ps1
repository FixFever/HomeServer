# Fix for:
# An unhandled exception has been thrown:
# OCP\AutoloadNotAllowedException: Autoload path not allowed: /var/www/html/apps/files_external/lib/service/globalstoragesservice.php in /var/www/html/lib/autoloader.php:141

Remove-Item -Recurse -Force \\wsl$\docker-desktop-data\data\docker\volumes\nextcloud_html\_data\apps\files_external