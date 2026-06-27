param(
    [ValidateSet('Status', 'Download')]
    [string]$Action = 'Status',

    [string]$RepoPath = '',
    [string]$RemoteUrl = 'https://github.com/jranlin2026/jixiangOS.git',
    [string]$DefaultBranch = 'codex/core-crm-polish'
)

$ErrorActionPreference = 'Stop'

if (-not $RepoPath) {
    $RepoPath = [string]::Concat(
        'D:\CODEX',
        [char]0x9879,
        [char]0x76EE,
        '\',
        [char]0x6781,
        [char]0x4EAB,
        'OS'
    )
}

function Invoke-Git {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Args)
    & git @Args
    if ($LASTEXITCODE -ne 0) {
        throw "git $($Args -join ' ') failed with exit code $LASTEXITCODE"
    }
}

function Ensure-Repo {
    if (-not (Test-Path -LiteralPath $RepoPath)) {
        $parent = Split-Path -Parent $RepoPath
        if ($parent -and -not (Test-Path -LiteralPath $parent)) {
            New-Item -ItemType Directory -Path $parent | Out-Null
        }
        Invoke-Git clone --branch $DefaultBranch $RemoteUrl $RepoPath
    }

    Push-Location $RepoPath
    try {
        Invoke-Git rev-parse --is-inside-work-tree | Out-Null
        $origin = (& git remote get-url origin 2>$null)
        if ($LASTEXITCODE -ne 0 -or $origin -ne $RemoteUrl) {
            $remotes = & git remote
            if ($remotes -contains 'origin') {
                Invoke-Git remote set-url origin $RemoteUrl
            } else {
                Invoke-Git remote add origin $RemoteUrl
            }
        }
    } finally {
        Pop-Location
    }
}

function Show-Status {
    Push-Location $RepoPath
    try {
        Invoke-Git status --short --branch
        Invoke-Git log -1 --oneline --decorate
        Invoke-Git remote -v
    } finally {
        Pop-Location
    }
}

function Download-Latest {
    Push-Location $RepoPath
    try {
        $dirty = (& git status --porcelain)
        if ($dirty) {
            $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
            Invoke-Git stash push -u -m "codex local changes before syncing jixiangOS $stamp"
        }

        Invoke-Git fetch origin --prune

        $branch = (& git branch --show-current).Trim()
        if (-not $branch) {
            $branch = $DefaultBranch
            Invoke-Git checkout $branch
        }

        Invoke-Git pull --ff-only origin $branch

        Invoke-Git status --short --branch
        Invoke-Git log -1 --oneline --decorate
        if ($dirty) {
            Invoke-Git stash list -n 3
        }
    } finally {
        Pop-Location
    }
}

Ensure-Repo

switch ($Action) {
    'Status' { Show-Status }
    'Download' { Download-Latest }
}
