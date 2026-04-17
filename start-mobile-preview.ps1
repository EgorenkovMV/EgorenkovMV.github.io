param(
    [int]$Port = 8000,
    [string]$Bind = "0.0.0.0"
)

$ErrorActionPreference = "Stop"

function Get-LocalIPv4Address {
    try {
        $addresses = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction Stop |
            Where-Object {
                $_.IPAddress -notlike "127.*" -and
                $_.IPAddress -notlike "169.254.*" -and
                $_.PrefixOrigin -ne "WellKnown"
            } |
            Select-Object -ExpandProperty IPAddress

        if ($addresses) {
            return $addresses[0]
        }
    }
    catch {
    }

    $ipconfigOutput = ipconfig
    foreach ($line in $ipconfigOutput) {
        if ($line -match "IPv4 Address[^\:]*:\s*(\d+\.\d+\.\d+\.\d+)") {
            if ($matches[1] -notlike "127.*" -and $matches[1] -notlike "169.254.*") {
                return $matches[1]
            }
        }
    }

    return "localhost"
}

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$ip = Get-LocalIPv4Address

Write-Host ""
Write-Host "SkillPoint mobile preview"
Write-Host "Local URL:  http://localhost:$Port"
Write-Host "Phone URL:  http://${ip}:$Port"
Write-Host "Bind host:  $Bind"
Write-Host ""
Write-Host "Keep this window open while testing on the phone."
Write-Host "If the phone cannot open the Wi-Fi URL, allow Python through Windows Firewall on Private networks."
Write-Host "Android USB option: after enabling USB debugging, run 'adb reverse tcp:$Port tcp:$Port' and open http://127.0.0.1:$Port on the phone."
Write-Host ""

Set-Location $repoRoot
python -m http.server $Port --bind $Bind
