$ErrorActionPreference = 'Stop'

$logPath = Join-Path $PSScriptRoot 'OnStartup.log'

function Write-StartupLog {
    param([Parameter(Mandatory)][string]$Message)

    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    Add-Content -LiteralPath $logPath -Encoding utf8 -Value "$timestamp $Message"
}

Write-StartupLog 'Startup actions started.'

# Send the existing startup notification without preventing the other actions on failure.
if (-not [string]::IsNullOrWhiteSpace($env:TELEGRAM_REPORT_URL)) {
    try {
        Invoke-WebRequest -Uri ($env:TELEGRAM_REPORT_URL + 'Server is up') -TimeoutSec 15 | Out-Null
        Write-StartupLog 'Startup notification sent.'
    }
    catch {
        Write-StartupLog "Startup notification failed: $($_.Exception.Message)"
    }
}
else {
    Write-StartupLog 'TELEGRAM_REPORT_URL is not set; notification skipped.'
}

# Docker Desktop can start after this logon task. Wait for the Engine, then restart
# the container to restore Docker Desktop host-network forwarding for port 444.
$dockerDeadline = (Get-Date).AddMinutes(10)
$dockerReady = $false
while ((Get-Date) -lt $dockerDeadline) {
    try {
        & docker.exe info *> $null
        if ($LASTEXITCODE -eq 0) {
            $dockerReady = $true
            break
        }
    }
    catch {
        # Docker CLI may be available before the Engine is ready.
    }

    Start-Sleep -Seconds 5
}

if (-not $dockerReady) {
    Write-StartupLog 'Docker Engine did not become ready within 10 minutes; Traefik was not restarted.'
}
else {
    Write-StartupLog 'Docker Engine is ready; waiting 15 seconds for Docker Desktop networking.'
    Start-Sleep -Seconds 15

    try {
        & docker.exe restart traefik *> $null
        if ($LASTEXITCODE -eq 0) {
            Write-StartupLog 'Docker Traefik container restarted.'

            $portDeadline = (Get-Date).AddSeconds(60)
            $portReady = $false
            while ((Get-Date) -lt $portDeadline) {
                if (Test-NetConnection -ComputerName 127.0.0.1 -Port 444 -InformationLevel Quiet -WarningAction SilentlyContinue) {
                    $portReady = $true
                    break
                }
                Start-Sleep -Seconds 3
            }

            if ($portReady) {
                Write-StartupLog 'Docker Traefik port 444 is reachable from Windows.'
            }
            else {
                Write-StartupLog 'Warning: port 444 is still unreachable from Windows after restarting Docker Traefik.'
            }
        }
        else {
            Write-StartupLog "Docker Traefik restart failed with exit code $LASTEXITCODE."
        }
    }
    catch {
        Write-StartupLog "Docker Traefik restart failed: $($_.Exception.Message)"
    }
}

Write-StartupLog 'Attaching the CO2 meter to WSL.'
try {
    & usbipd.exe attach --wsl --busid 1-6 *> $null
    if ($LASTEXITCODE -eq 0) {
        Write-StartupLog 'CO2 meter attached to WSL.'
    }
    else {
        Write-StartupLog "CO2 meter attach failed with exit code $LASTEXITCODE."
    }
}
catch {
    Write-StartupLog "CO2 meter attach failed: $($_.Exception.Message)"
}

Write-StartupLog 'Startup actions finished.'
