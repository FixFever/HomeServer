
## How to display original photos instead of previews in nextcloud

#### nextcloud\apps\viewer\js\viewer-main.js
Replace:
```
return r?Ji()?(0,Yi.nu)("/apps/files_sharing/publicpreview/".concat(ea(),"?file=").concat(ra(n),"&").concat(i)):(0,Yi.nu)("/core/preview?".concat(i)):o}}};
```
To:
```
return r&&!r?Ji()?(0,Yi.nu)("/apps/files_sharing/publicpreview/".concat(ea(),"?file=").concat(ra(n),"&").concat(i)):(0,Yi.nu)("/core/preview?".concat(i)):o}}};
```

#### nextcloud\apps\files_sharing\lib\Controller\PublicPreviewController.php
Replace:
```
$f = $this->previewManager->getPreview($node, -1, -1, false);
$response = new FileDisplayResponse($f, Http::STATUS_OK, ['Content-Type' => $f->getMimeType()]);
```
To:
```
$response = new FileDisplayResponse($node, Http::STATUS_OK, ['Content-Type' => $node->getMimeType()]);
```

#### nextcloud\apps\files_sharing\js\public.js
Replace:
```
img.attr('src', OC.generateUrl('/apps/files_sharing/publicpreview/' + token + '?' + OC.buildQueryString(params)));
```
To:
```
img.attr('src', $('#previewURL').val());
```


#### (Optional) nextcloud\config\config.php
Add:
```
  'preview_max_x' => 256,
  'preview_max_y' => 256
```
