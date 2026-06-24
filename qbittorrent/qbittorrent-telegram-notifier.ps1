# script for qbittorrent:
# on add:
# pwsh -file "C:\git\server\qbittorrent\qbittorrent-telegram-notifier.ps1" -EventType add -TorrentName "%N" -TorrentSize "%Z" -SavePath "%F"
# on complete:
# pwsh -file "C:\git\server\qbittorrent\qbittorrent-telegram-notifier.ps1" -EventType complete -TorrentName "%N" -TorrentSize "%Z" -SavePath "%F"


param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("add", "complete")]
    [string]$EventType,
    
    [Parameter(Mandatory=$true)]
    [string]$TorrentName,
    
    [Parameter(Mandatory=$false)]
    [long]$TorrentSize = 0,
    
    [Parameter(Mandatory=$false)]
    [string]$SavePath = ""
)


$BotToken = $Env:TELEGRAM_BOT_TOKEN
$ChatID = $Env:CHAT_ID

# Функция отправки сообщения в Telegram
function Send-TelegramMessage {
    param(
        [string]$Text
    )
    
    $Url = "https://api.telegram.org/bot$BotToken/sendMessage"
    
    $Body = @{
        chat_id = $ChatID
        text = $Text
        parse_mode = "HTML"
        disable_notification = $false
    } | ConvertTo-Json
    
    try {
        $Response = Invoke-RestMethod -Uri $Url -Method Post -Body $Body -ContentType "application/json" -ErrorAction Stop
        
        if ($Response.ok) {
            Write-Host "Сообщение отправлено успешно!" -ForegroundColor Green
            return $true
        } else {
            Write-Error "Ошибка отправки сообщения: $($Response.description)"
            return $false
        }
    }
    catch {
        Write-Error "Ошибка при отправке сообщения: $_"
        return $false
    }
}

# Функция форматирования размера файла
function Format-FileSize {
    param([long]$Bytes)
    
    if ($Bytes -ge 1TB) { return "{0:N2} TB" -f ($Bytes / 1TB) }
    elseif ($Bytes -ge 1GB) { return "{0:N2} GB" -f ($Bytes / 1GB) }
    elseif ($Bytes -ge 1MB) { return "{0:N2} MB" -f ($Bytes / 1MB) }
    elseif ($Bytes -ge 1KB) { return "{0:N2} KB" -f ($Bytes / 1KB) }
    else { return "$Bytes B" }
}

# Создание сообщения в зависимости от события
$Message = ""

switch ($EventType) {
    "add" {
        $SizeFormatted = Format-FileSize -Bytes $TorrentSize
        $Message = @"
<b>📥 Торрент добавлен!</b>

<b>📝Название:</b> $TorrentName
<b>📁Папка:</b> $SavePath
<b>📊Размер:</b> $SizeFormatted
"@
    }
    
    "complete" {
        $SizeFormatted = Format-FileSize -Bytes $TorrentSize
        $Message = @"
<b>✅ Торрент скачан!</b>

<b>📝Название:</b> $TorrentName
<b>📁Папка:</b> $SavePath
<b>📊Размер:</b> $SizeFormatted
"@
    }
}

# Отправка сообщения
if ($Message) {
    Send-TelegramMessage -Text $Message
}