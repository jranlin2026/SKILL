---
name: start-jixiangos-local
description: Start the local jranlin2026/jixiangOS development environment and diagnose startup failures. Use when the user asks to 启动服务访问, 启动极享OS, start local jixiangOS, open http://127.0.0.1, or troubleshoot slow/failed local startup involving Vite, the Express API, MySQL, Prisma, ports 3000/3001/3002/3306, or stale node/mysqld processes.
---

# Start jixiangOS Local

Use this skill to start the local 极享OS project reliably.

Default repo:

```text
D:\CODEX项目\极享OS
```

Default local services:

```text
Frontend: http://127.0.0.1:3002/
API:      http://127.0.0.1:3001/api
MySQL:    127.0.0.1:3306
```

## Fast Path

Run the bundled script first:

```powershell
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\.codex\skills\start-jixiangos-local\scripts\start-jixiangos-local.ps1"
```

The script should:

1. Detect whether `3000` is occupied. Do not kill unrelated apps. Use `3002` for Vite because `3000` is often occupied by WeChat Store Assistant on this machine.
2. Start MySQL if `3306` is not listening.
3. Stop stale `tsx watch server/index.ts` processes from this repo when they exist but are not listening on `3001`.
4. Start the API on `3001`.
5. Start or reuse the frontend on `3002`.
6. Verify `http://127.0.0.1:3002/` and `http://127.0.0.1:3001/api/auth/me`.

## Manual Recovery

Use these checks when the script fails or the user asks what happened.

### Check Ports

```powershell
Get-NetTCPConnection -LocalPort 3000,3001,3002,3306 -ErrorAction SilentlyContinue |
  Select-Object LocalPort,State,OwningProcess
```

If `3000` is occupied by another desktop app, keep it. Start Vite on `3002`.

### Check Processes

```powershell
Get-CimInstance Win32_Process -Filter "name = 'node.exe'" |
  Where-Object { $_.CommandLine -match '极享OS|tsx|vite|server/index' } |
  Select-Object ProcessId,CommandLine
```

Only stop stale project-specific API processes. Do not stop unrelated Node processes such as MCP servers.

### Start MySQL

Known local MySQL paths on this machine:

```text
C:\Program Files\MySQL\MySQL Server 8.4\bin\mysqld.exe
C:\ProgramData\MySQL\MySQL Server 8.4\my.ini
```

Start with quoted config path:

```powershell
Start-Process -FilePath "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysqld.exe" `
  -ArgumentList "--defaults-file=`"C:\ProgramData\MySQL\MySQL Server 8.4\my.ini`"" `
  -WindowStyle Hidden
```

Then verify:

```powershell
Get-NetTCPConnection -LocalPort 3306 -ErrorAction SilentlyContinue
```

### Start API

```powershell
$apiLog = Join-Path $env:TEMP 'jixiangos-api-3001.log'
Start-Process -FilePath "cmd.exe" `
  -ArgumentList "/c", "npm.cmd run dev:api > `"$apiLog`" 2>&1" `
  -WorkingDirectory "D:\CODEX项目\极享OS" `
  -WindowStyle Hidden
```

If it fails, read:

```powershell
Get-Content -Tail 120 (Join-Path $env:TEMP 'jixiangos-api-3001.log')
```

Common failure:

```text
Can't reach database server at 127.0.0.1:3306
```

This means MySQL is not listening or the wrong MySQL instance started.

### Start Frontend

```powershell
$webLog = Join-Path $env:TEMP 'jixiangos-web-3002.log'
Start-Process -FilePath "cmd.exe" `
  -ArgumentList "/c", "npx.cmd vite --host 127.0.0.1 --port 3002 --strictPort > `"$webLog`" 2>&1" `
  -WorkingDirectory "D:\CODEX项目\极享OS" `
  -WindowStyle Hidden
```

## Verify Before Reporting Success

Always verify both:

```powershell
Invoke-WebRequest -UseBasicParsing http://127.0.0.1:3002/ -TimeoutSec 8
Invoke-WebRequest -UseBasicParsing http://127.0.0.1:3001/api/auth/me -TimeoutSec 8
```

`/api/auth/me` returning `200` is acceptable even when logged out; the key is that the API responds and Vite proxy is not throwing `ECONNREFUSED`.

## Report Shape

Tell the user:

- The access URL.
- Which ports are running.
- Whether MySQL was started.
- Any blocker, especially database or port conflict.

Keep the final answer short.
