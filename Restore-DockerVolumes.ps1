<#
.SYNOPSIS
    Восстанавливает Docker volumes из архивов .tar.gz, учитывая вложенную папку /data.
.DESCRIPTION
    Скрипт распаковывает архивы и копирует содержимое папки /data в соответствующий volume.
.EXAMPLE
    .\Restore-DockerVolumes.ps1 -BackupDir "H:\backups\docker-volumes"
#>

param (
    [string]$BackupDir = "H:\backups\docker-volumes"
)

# Проверяем, установлен ли Docker
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Error "Docker не найден. Убедитесь, что Docker Desktop установлен и запущен."
    exit 1
}

# Проверяем существование папки с бэкапами
if (-not (Test-Path $BackupDir)) {
    Write-Error "Папка с бэкапами не найдена: $BackupDir"
    exit 1
}

# Получаем список архивов .tar.gz
$backupFiles = Get-ChildItem -Path $BackupDir -Filter *.tar.gz

if ($backupFiles.Count -eq 0) {
    Write-Host "Нет архивов .tar.gz в папке $BackupDir" -ForegroundColor Yellow
    exit 0
}

Write-Host "Найдено архивов для восстановления: $($backupFiles.Count)`n" -ForegroundColor Cyan

foreach ($file in $backupFiles) {
    # Удаляем все расширения (.tar.gz, .gz, .tar)
    $volumeName = $file.BaseName -replace '\.(tar|gz)$','' -replace '\.tar$',''

    Write-Host "→ Восстанавливается volume: $volumeName" -ForegroundColor Green

    # 1. Создаём volume (если ещё не существует)
    docker volume create $volumeName 2>&1 | Out-Null

    # 2. Распаковываем архив во временную папку
    $tempDir = Join-Path -Path $env:TEMP -ChildPath "docker_restore_$([System.Guid]::NewGuid().ToString("N"))"
    New-Item -ItemType Directory -Path $tempDir | Out-Null

    try {
        Write-Host "Распаковка архива..."
        tar -xzf $file.FullName -C $tempDir

        # 3. Проверяем наличие папки /data в распакованном архиве
        $dataDir = Join-Path -Path $tempDir -ChildPath "data"
        if (-not (Test-Path $dataDir)) {
            Write-Error "В архиве $($file.Name) нет папки /data. Пропускаем."
            continue
        }

        # 4. Копируем СОДЕРЖИМОЕ папки /data в volume
        Write-Host "Копирование данных в volume..."
        docker run --rm `
            -v "${volumeName}:/target" `
            -v "${dataDir}:/backup_data" `
            alpine sh -c "cp -R /backup_data/* /target/ && chmod -R 777 /target" 2>&1 | Out-Null

        Write-Host "Готово! Проверить: docker run --rm -v ${volumeName}:/data alpine ls /data" -ForegroundColor Cyan
    }
    catch {
        Write-Error "Ошибка при восстановлении volume $volumeName : $_"
    }
    finally {
        # Удаляем временную папку
        Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
    }

    Write-Host ""
}

Write-Host "Все volumes восстановлены!" -ForegroundColor Green

Write-Host "Применяю права доступа к файлам..."

docker run --rm --privileged -v pgadmin:/var/lib/pgadmin alpine chown -R 5050:5050 /var/lib/pgadmin
docker run --rm --privileged -v pgadmin:/var/lib/pgadmin alpine chown -R 775 /var/lib/pgadmin

docker run --rm --privileged -v nextcloud_html:/var/www/html alpine chown -R 33:33 /var/www/html
docker run --rm --privileged -v nextcloud_php:/usr/local/etc/php alpine chown -R 33:33 /usr/local/etc/php

docker run --rm --privileged -v homeassistant:/config alpine chown -R root:root /config

Write-Host "Права доступа установлены!" -ForegroundColor Green
