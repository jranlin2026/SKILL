param(
  [string]$RepoPath = "",
  [int]$FrontendPort = 3002,
  [int]$ApiPort = 3001,
  [int]$MysqlPort = 3306
)

$ErrorActionPreference = "Stop"

function Write-Step([string]$Message) {
  Write-Host "[jixiangOS] $Message"
}

function Get-PortOwner([int]$Port) {
  Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue |
    Where-Object { $_.State -eq "Listen" } |
    Select-Object -First 1
}

function Test-Http([string]$Url) {
  try {
    $response = Invoke-WebRequest -UseBasicParsing $Url -TimeoutSec 8
    return $response.StatusCode
  } catch {
    if ($_.Exception.Response) {
      return [int]$_.Exception.Response.StatusCode
    }
    return $null
  }
}

if ([string]::IsNullOrWhiteSpace($RepoPath) -or -not (Test-Path $RepoPath)) {
  $repoParent = "D:\CODEX$([char]0x9879)$([char]0x76ee)"
  $repoName = "$([char]0x6781)$([char]0x4eab)OS"
  $RepoPath = Join-Path $repoParent $repoName
}

if (-not (Test-Path $RepoPath)) {
  throw "Repo path not found: $RepoPath"
}

$webLog = Join-Path $env:TEMP "jixiangos-web-$FrontendPort.log"
$apiLog = Join-Path $env:TEMP "jixiangos-api-$ApiPort.log"

Write-Step "Checking ports..."
$port3000 = Get-PortOwner 3000
if ($port3000) {
  $process = Get-Process -Id $port3000.OwningProcess -ErrorAction SilentlyContinue
  Write-Step "Port 3000 is occupied by PID $($port3000.OwningProcess) $($process.ProcessName). Using $FrontendPort for Vite."
}

$mysqlOwner = Get-PortOwner $MysqlPort
if (-not $mysqlOwner) {
  Write-Step "MySQL is not listening on $MysqlPort. Starting local MySQL..."
  $mysqld = "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysqld.exe"
  $myIni = "C:\ProgramData\MySQL\MySQL Server 8.4\my.ini"
  if (-not (Test-Path $mysqld)) { throw "mysqld.exe not found: $mysqld" }
  if (-not (Test-Path $myIni)) { throw "my.ini not found: $myIni" }
  Start-Process -FilePath $mysqld -ArgumentList "--defaults-file=`"$myIni`"" -WindowStyle Hidden
  Start-Sleep -Seconds 8
  $mysqlOwner = Get-PortOwner $MysqlPort
}
if (-not $mysqlOwner) {
  throw "MySQL did not start on port $MysqlPort."
}
Write-Step "MySQL listening on $MysqlPort."

$apiOwner = Get-PortOwner $ApiPort
if (-not $apiOwner) {
  $staleApiProcesses = Get-CimInstance Win32_Process -Filter "name = 'node.exe'" |
    Where-Object { $_.CommandLine -match [regex]::Escape($RepoPath) -and $_.CommandLine -match 'tsx.*server/index|server/index\.ts' }
  foreach ($proc in $staleApiProcesses) {
    Write-Step "Stopping stale API process PID $($proc.ProcessId)."
    Stop-Process -Id $proc.ProcessId -Force -ErrorAction SilentlyContinue
  }

  Remove-Item $apiLog -Force -ErrorAction SilentlyContinue
  Write-Step "Starting API on $ApiPort..."
  Start-Process -FilePath "cmd.exe" `
    -ArgumentList "/c", "npm.cmd run dev:api > `"$apiLog`" 2>&1" `
    -WorkingDirectory $RepoPath `
    -WindowStyle Hidden
  Start-Sleep -Seconds 8
  $apiOwner = Get-PortOwner $ApiPort
}
if (-not $apiOwner) {
  Write-Host "API log: $apiLog"
  if (Test-Path $apiLog) { Get-Content -Tail 120 $apiLog }
  throw "API did not start on port $ApiPort."
}
Write-Step "API listening on $ApiPort."

$webOwner = Get-PortOwner $FrontendPort
if (-not $webOwner) {
  Remove-Item $webLog -Force -ErrorAction SilentlyContinue
  Write-Step "Starting frontend on $FrontendPort..."
  Start-Process -FilePath "cmd.exe" `
    -ArgumentList "/c", "npx.cmd vite --host 127.0.0.1 --port $FrontendPort --strictPort > `"$webLog`" 2>&1" `
    -WorkingDirectory $RepoPath `
    -WindowStyle Hidden
  Start-Sleep -Seconds 5
  $webOwner = Get-PortOwner $FrontendPort
}
if (-not $webOwner) {
  Write-Host "Frontend log: $webLog"
  if (Test-Path $webLog) { Get-Content -Tail 80 $webLog }
  throw "Frontend did not start on port $FrontendPort."
}
Write-Step "Frontend listening on $FrontendPort."

$webStatus = Test-Http "http://127.0.0.1:$FrontendPort/"
$apiStatus = Test-Http "http://127.0.0.1:$ApiPort/api/auth/me"

Write-Step "Verification:"
Write-Host "Frontend http://127.0.0.1:$FrontendPort/ => $webStatus"
Write-Host "API      http://127.0.0.1:$ApiPort/api/auth/me => $apiStatus"

if (-not $webStatus -or -not $apiStatus) {
  throw "Service verification failed."
}

Write-Step "Ready: http://127.0.0.1:$FrontendPort/"
