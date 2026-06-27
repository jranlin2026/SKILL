---
name: syncing-jixiangos
description: Use when working with the jranlin2026/jixiangOS GitHub repository, especially requests to download, update, pull, clone, upload, commit, push, publish, or sync the latest jixiangOS code.
---

# Syncing jixiangOS

## Overview

Use this skill for repeatable jixiangOS repository sync work. Keep the local repo safe first: inspect status, preserve uncommitted changes, then pull or push deliberately.

Repository defaults:

```text
Repo: jranlin2026/jixiangOS
URL: https://github.com/jranlin2026/jixiangOS.git
Local path: D:\CODEX项目\极享OS
Primary working branch: codex/core-crm-polish
```

## Quick Commands

Prefer the bundled helper for routine status/download tasks:

```powershell
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\.codex\skills\syncing-jixiangos\scripts\sync-jixiangos.ps1" -Action Status
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\.codex\skills\syncing-jixiangos\scripts\sync-jixiangos.ps1" -Action Download
```

For uploads, inspect the diff first and only stage intentional files:

```powershell
git status --short --branch
git diff
git add <intentional-files>
git commit -m "clear message"
git push origin HEAD
```

## Download Workflow

1. Resolve the repo path. If `D:\CODEX项目\极享OS` exists and is a git repo, use it. If not, clone:

```powershell
git clone https://github.com/jranlin2026/jixiangOS.git "D:\CODEX项目\极享OS"
```

2. Verify the remote points to `jranlin2026/jixiangOS`:

```powershell
git remote -v
```

If `origin` is missing or wrong, fix it:

```powershell
git remote set-url origin https://github.com/jranlin2026/jixiangOS.git
```

3. Check local changes before pulling:

```powershell
git status --short --branch
```

If there are uncommitted changes, stash them with a clear message:

```powershell
git stash push -u -m "codex local changes before syncing jixiangOS"
```

4. Fetch and pull the current branch with fast-forward only:

```powershell
git fetch origin --prune
git pull --ff-only origin HEAD
```

If `HEAD` pull fails, identify the current branch and pull that branch explicitly:

```powershell
git branch --show-current
git pull --ff-only origin codex/core-crm-polish
```

5. Report the resulting branch, latest commit, clean/dirty status, and stash entry if one was created.

## Upload Workflow

1. Inspect the working tree:

```powershell
git status --short --branch
git diff
```

2. If changes are unrelated or ambiguous, ask which files to include. Do not stage everything blindly when unrelated work exists.

3. Run appropriate verification before committing. For this repo, at minimum:

```powershell
npm.cmd run build
```

4. Stage intentional files, commit with a specific message, and push the current branch:

```powershell
git add <intentional-files>
git commit -m "type: concise change summary"
git push origin HEAD
```

5. Report pushed branch, commit hash, and any verification that was run.

## Common Mistakes

- Do not use `git reset --hard`, `git checkout -- .`, or destructive cleanup unless the user explicitly asks.
- Do not pop an existing stash automatically after downloading; first show `git stash list` and ask or decide based on the current task.
- Do not push without reading `git status` and `git diff`.
- Do not assume `main` is the desired branch when the local repo is already on `codex/core-crm-polish`.
