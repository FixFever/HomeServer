# script for scheduler:
# powershell  -WindowStyle hidden -file "C:\git\server\nextcloud\NextcloudGeneratePreviews.ps1" -WindowStyle Hidden

# on error
# OCP\AutoloadNotAllowedException: Autoload path not allowed: /var/www/html/apps/files_external/lib/service/globalstoragesservice.php in /var/www/html/lib/autoloader.php:141
# delete /var/www/html/apps/files_external

docker exec -u 33 nextcloud /var/www/html/occ preview:pre-generate