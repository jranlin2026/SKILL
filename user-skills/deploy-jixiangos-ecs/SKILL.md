---
name: deploy-jixiangos-ecs
description: Deploy the local jranlin2026/jixiangOS project to the Alibaba Cloud ECS server. Use when the user asks to publish, update, redeploy, release, or put the latest jixiangOS code on the server at 120.24.250.244.
---

# Deploy jixiangOS ECS

## Workflow

Use the existing repo deploy script from `D:\CODEX项目\极享OS`.

1. Inspect local status before deploying:

```powershell
git status --short --branch
```

2. If the latest code has not been committed/pushed and the user asked for a code upload too, use `$syncing-jixiangos` first. Deployment can still run from the local workspace when the user explicitly wants the current local code deployed.

3. Set deployment environment variables without writing secrets to files:

```powershell
$env:JIXIANG_DEPLOY_HOST="120.24.250.244"
$env:JIXIANG_DEPLOY_USER="root"
$env:JIXIANG_DEPLOY_PASSWORD="<server password>"
$env:PYTHONIOENCODING="utf-8"
```

4. Run deployment from the repo root. The deploy script now reuses the server's current `node_modules` with hard links by default and then runs `npm install --prefer-offline`, so normal code-only releases avoid slow full dependency installs:

```powershell
scripts\deploy\deploy-ecs.cmd
```

Use `--skip-build` only when a fresh local build has already passed in the same turn:

```powershell
scripts\deploy\deploy-ecs.cmd --skip-build
```

Do not use `--skip-build` if `dist` may contain old artifacts. The normal deploy path cleans `dist`, rebuilds without production sourcemaps, and keeps the release package small.

If dependencies were changed, or the server dependency cache looks broken, force a clean dependency install:

```powershell
scripts\deploy\deploy-ecs.cmd --fresh-install
```

5. Verify public health:

```powershell
curl.exe -sS --max-time 20 http://120.24.250.244/api/health
```

Expected response includes:

```json
{"ok":true,"database":true}
```

## Failure Handling

- If Windows output fails with encoding errors, set `PYTHONIOENCODING=utf-8` and make sure `scripts/deploy/deploy-ecs.py` uses safe printing for remote output.
- If the deploy script fails at the final local server health check with `curl: (7) Failed to connect to 127.0.0.1 port 3001`, do not immediately redeploy. This often means PM2 restarted successfully but the API was not ready at the exact health-check moment. Wait 5-10 seconds and re-check public health:
- The remote health check has a retry loop. If it still fails, do not immediately redeploy. Wait 5-10 seconds and re-check public health:

```powershell
curl.exe -sS --max-time 20 http://120.24.250.244/api/health
```

- If public health returns `{"ok":true,"database":true}`, treat the deployment as successful even if the script exited non-zero at the first health check.
- If public health still fails, inspect the server through SSH or a short Paramiko snippet:

```powershell
$env:JIXIANG_DEPLOY_HOST="120.24.250.244"
$env:JIXIANG_DEPLOY_USER="root"
$env:JIXIANG_DEPLOY_PASSWORD="<server password>"
```

Then run server-side checks without printing the password:

```bash
curl -fsS http://127.0.0.1:3001/api/health
pm2 describe jixiang-os-api
pm2 logs jixiang-os-api --lines 80 --nostream
```

- If the deploy script failed after uploading and switching release, clean temporary release files once health is verified:

```bash
rm -f /tmp/jixiang-os-release-*.zip /tmp/jixiang-os.env-*
```

Run server commands through SSH or a short Paramiko snippet. Do not expose the server password in the final answer.

## Notes

- The deploy script preserves `/opt/jixiang-os/.env` on the server.
- The deploy script reuses `/opt/jixiang-os/node_modules` with hard links by default to avoid slow full dependency installs. Use `--fresh-install` after dependency upgrades or when dependency errors appear.
- The deploy script excludes `.env`, `node_modules`, `.git`, logs, zip files, and `.codex-*` files from the release package.
- The server app directory is `/opt/jixiang-os`; PM2 process name is `jixiang-os-api`; API port is `3001`.
- Do not commit or print server passwords.
