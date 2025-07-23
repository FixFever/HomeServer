<#
.SYNOPSIS
Проверяет и при необходимости перезапускает Docker Desktop

.DESCRIPTION
Этот скрипт проверяет статус Docker Desktop с помощью встроенной команды CLI.
Если Docker Desktop остановлен, скрипт пытается его перезапустить.
#>

# Проверяем, установлен ли Docker CLI
if (-not (Get-Command "docker" -ErrorAction SilentlyContinue)) {
    Write-Host "Docker CLI не найден. Убедитесь, что Docker Desktop установлен." -ForegroundColor Red
    exit 1
}

# Функция для проверки статуса Docker Desktop
function Get-DockerDesktopStatus {
    try {
        $status = docker desktop status 2>&1
        if ($status -like "*running*") {
            return "Running"
        } elseif ($status -like "*stopped*") {
            return "Stopped"
        } else {
            return "Unknown"
        }
    }
    catch {
        Write-Host "Ошибка при проверке статуса Docker Desktop: $_" -ForegroundColor Red
        return "Error"
    }
}

# Функция для перезапуска Docker Desktop
function Restart-DockerDesktop {
    Write-Host "Попытка перезапуска Docker Desktop..."
    
    try {
        # Перезапускаем Docker Desktop через CLI
        docker desktop restart
        
        # Даем время на запуск
        Start-Sleep -Seconds 20
        
        # Проверяем статус после перезапуска
        $newStatus = Get-DockerDesktopStatus
        
        if ($newStatus -eq "Running") {
            SendToTelegram("Docker Desktop успешно перезапущен.");
            return $true
        } else {
            SendToTelegram("Не удалось перезапустить Docker Desktop. Текущий статус: $newStatus");
            return $false
        }
    }
    catch {
        SendToTelegram("Ошибка при перезапуске Docker Desktop: $_");
        return $false
    }
}

function SendToTelegram($message) {
    Write-Host $message
    Invoke-WebRequest -URI ($Env:TELEGRAM_REPORT_URL + $message)
}

Write-Host "Проверка состояния Docker Desktop..."

$status = Get-DockerDesktopStatus

switch ($status) {
    "Running" {
        Write-Host "Docker Desktop уже работает." -ForegroundColor Green
        exit 0
    }
    "Stopped" {
        SendToTelegram("Docker Desktop остановлен. Пытаюсь перезапустить...");
        $result = Restart-DockerDesktop
        if (-not $result) { exit 1 }
    }
    "Unknown" {
        Write-Host "Не удалось определить статус Docker Desktop." -ForegroundColor Red
        exit 1
    }
    "Error" {
        Write-Host "Произошла ошибка при проверке статуса Docker Desktop." -ForegroundColor Red
        exit 1
    }
}

Write-Host "Проверка завершена успешно."
exit 0