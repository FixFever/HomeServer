ARG NEXTCLOUD_IMAGE
FROM ${NEXTCLOUD_IMAGE}

# For enable .mov preview generation:
# Add next lines to /var/www/html/config/config.php file of nextcloud:
# 
# 'enabledPreviewProviders' =>[
#           'OC\Preview\PNG',
#           'OC\Preview\JPEG',
#           'OC\Preview\GIF',
#           'OC\Preview\BMP',
#           'OC\Preview\XBitmap',
#           'OC\Preview\MarkDown',
#           'OC\Preview\OpenDocument',
#           'OC\Preview\HEIC',
#           'OC\Preview\Movie',
#   ],
RUN apt update && apt install -y --no-install-recommends ffmpeg