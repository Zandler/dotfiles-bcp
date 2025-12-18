$ErrorActionPreference = 'SilentlyContinue' 

<#
    .SYNOPSIS
    Powershell script for install and configure portaltil
    
    .DESCRIPTION
    Requirements: 
        Powershell > 5
        Windows 11
    Steps:
        - Install scoop
        - install git
        - clone repo
        - execute bootstrap.ps1
#>

function InstallScoop {
    try {
        Clear-Host
        Write-Host "Verificando se o scoop está instalado" -ForegroundColor DarkCyan
        Start-Sleep -Seconds 2
        
        scoop --version

        Write-Host "Scoop encontrado." -ForegroundColor DarkCyan
        Start-Sleep -Seconds 2
    }
    catch {
        Clear-Host
        Write-Host "Scoop não encontrado. Instalando ..." -ForegroundColor DarkBlue
        Start-Sleep -Seconds 2 
        
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
        Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    }
}

function CloneRepo {

    
    Write-Host "Verificando se a pasta .dotfiles existe no portátil em '$HOME' " -ForegroundColor DarkCyan
    if (Test-Path $HOME\.dotfiles) {
        Write-Host "Pasta encontrada. Atualizando..." -ForegroundColor DarkGreen
        cd $HOME\.dotfiles ; git pull
        Start-Sleep -Seconds 2
        Clear-Host
    }

    Write-Host "Baixando as configurações para $HOME\.dotfiles ..."
    git clone https://github.com/zandler/dotfiles-bcp.git $HOME\.dotfiles 
    cd $HOME\.dotfiles ; 
    Start-Sleep -Seconds 2
}

Clear-Host

write-host "Verificando requisitos..." -foregroundcolor darkcyan
InstallScoop
Start-Sleep -Seconds 2

Clear-Host

Write-Host "Instalndo git" 
scoop install main/git
Start-Sleep -Seconds2

Clear-Host 

CloneRepo

Write-Host "Agora vamos inciar as configurações." -ForegroundColor DarkCyan
Set-Location -Path $HOME\.dotfiles       
.\bootstrap.ps1