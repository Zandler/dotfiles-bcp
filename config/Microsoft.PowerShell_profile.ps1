# ============================================================
# PowerShell Setup — Aliases, Git funcs, Kubernetes wrappers
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# ---------------------------
# Terminal Modules
# ---------------------------
$requiredModules = @(
    "Terminal-Icons",
    "PSReadLine"
)

foreach ($module in $requiredModules) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Write-Warning "Módulo obrigatório não encontrado: $module"
    } else {
        Import-Module $module -Scope Global
    }
}

# ---------------------------
# PSReadLine Config
# ---------------------------
Set-PSReadLineKeyHandler -Key Tab        -Function Complete
Set-PSReadLineOption       -PredictionViewStyle ListView
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key UpArrow   -Function HistorySearchBackward


# ============================================================
# Kubernetes Aliases via Kubecolor
# ============================================================

# ---------------------------
# Validate Kubecolor
# ---------------------------
if (-not (Get-Command kubecolor -ErrorAction SilentlyContinue)) {
    Write-Error "kubecolor não encontrado. Instale antes de continuar."
    exit 1
}

# ---------------------------
# Alias Helper
# ---------------------------
function New-KubeAlias {
    param (
        [Parameter(Mandatory)][string]$Alias,
        [Parameter(Mandatory)][string]$Command
    )

    if (Get-Alias -Name $Alias -ErrorAction SilentlyContinue) {
        Write-Verbose "Alias já existente, ignorando: $Alias"
        return
    }

    Write-Verbose "Criando alias: $Alias -> $Command"
    Set-Alias -Name $Alias -Value $Command
}

# ---------------------------
# Core Aliases
# ---------------------------

# GET
New-KubeAlias kgp 'kubecolor get pods'
New-KubeAlias kgs 'kubecolor get services'
New-KubeAlias kgd 'kubecolor get deployments'
New-KubeAlias kgn 'kubecolor get nodes'
New-KubeAlias kgi 'kubecolor get ingress'

# DELETE
New-KubeAlias kdp 'kubecolor delete pod'
New-KubeAlias kdd 'kubecolor delete deployment'
New-KubeAlias kds 'kubecolor delete service'

# DESCRIBE
New-KubeAlias ksp 'kubecolor describe pod'
New-KubeAlias ksd 'kubecolor describe deployment'
New-KubeAlias ksn 'kubecolor describe node'

# CREATE
New-KubeAlias kcr 'kubecolor create -f'

# EDIT
New-KubeAlias ked 'kubecolor edit deployment'
New-KubeAlias kep 'kubecolor edit pod'

# RUN
New-KubeAlias krun 'kubecolor run'

# EXEC
New-KubeAlias kexec 'kubecolor exec'


# ============================================================
# Git + Utils Aliases
# ============================================================

function ls  { eza -lbGd --header --git --sort=modified --color=always --group-directories-first --icons }
function ll  { eza --tree --level=2 --color=always --group-directories-first --icons }
function ga  { git add . }
function gca { git commit --amend --verbose }
function gco { git checkout }
function gcob { git checkout -b }
function gs  { git status -sb }
function gl  { git log --oneline }
function glc { git log -1 HEAD --stat }
function grb { git branch -r -v }
function gcm { git commit -m }

function glbm  { git for-each-ref --sort=-committerdate --format='%(refname:short) %09 %(committerdate:relative)' refs/heads/ }
function glbmr { git for-each-ref --sort=-committerdate --format='%(refname:short) %09 %(committerdate:relative)' refs/remotes/ }


# ============================================================
# Kubernetes Wrapper — Advanced Execution Layer
# ============================================================

function Invoke-KubeColor {
    [CmdletBinding(PositionalBinding=$false)]
    param(
        [Parameter(Mandatory)][string] $Subcommand,
        [string] $Namespace,
        [switch] $AllNamespaces,
        [string] $Context,
        [string] $Output,
        [switch] $Watch,
        [switch] $WatchOnly,
        [switch] $Wide,
        [string] $Selector,
        [string] $FieldSelector,
        [int]    $Limit,
        [int]    $ChunkSize,
        [string] $SortBy,
        [switch] $NoHeaders,
        [string] $Kubeconfig,
        [Parameter(ValueFromRemainingArguments)][string[]] $RemainingArgs
    )

    $argsList = @(
        $Subcommand.Split(' ', 2)
    )

    if ($Namespace)     { $argsList += @('-n', $Namespace) }
    if ($AllNamespaces) { $argsList += '-A' }
    if ($Context)       { $argsList += @('--context', $Context) }
    if ($Output)        { $argsList += @('-o', $Output) }
    if ($Watch)         { $argsList += '-w' }
    if ($WatchOnly)     { $argsList += '--watch-only' }
    if ($Wide)          { $argsList += '--wide' }
    if ($Selector)      { $argsList += @('-l', $Selector) }
    if ($FieldSelector) { $argsList += @('--field-selector', $FieldSelector) }
    if ($Limit)         { $argsList += @('--limit', $Limit) }
    if ($ChunkSize)     { $argsList += @('--chunk-size', $ChunkSize) }
    if ($SortBy)        { $argsList += @('--sort-by', $SortBy) }
    if ($NoHeaders)     { $argsList += '--no-headers' }
    if ($Kubeconfig)    { $argsList += @('--kubeconfig', $Kubeconfig) }
    if ($RemainingArgs) { $argsList += $RemainingArgs }

    Write-Verbose ("kubecolor " + ($argsList -join ' '))
    & kubecolor @argsList
}


# ============================================================
# Startup — Starship
# ============================================================

Set-Variable -Name STARSHIP_CONFIG -Value "$HOME\.dotfiles\starship\starship.toml"
Invoke-Expression (&starship init powershell)
