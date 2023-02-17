# script for scheduler:
# powershell -file "C:\git\server\nextcloud\NextcloudGeneratePreviews.ps1" -WindowStyle Hidden

docker exec -u 33 nextcloud /var/www/html/occ preview:pre-generate