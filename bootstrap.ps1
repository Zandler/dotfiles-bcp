$ErrorActionPreference = 'SilentlyContinue'

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

function AddScoopButckets {
    Clear-Host

    $BUCKETS="extras",
            "versions",
            "nerd-fonts"


    Write-Host "Adicionando repositórios" -ForegroundColor DarkCyan
    Start-Sleep -Seconds 3

    foreach($bucket in $BUCKETS)
    {
        Clear-Host
        Write-Host "Adicionando repositório: "  $bucket  -ForegroundColor DarkCyan
        Start-Sleep -Seconds 2
        scoop bucket add $bucket

    }

    Write-Host "Atualizando repositórios" -ForegroundColor DarkCyan
    Start-Sleep -Seconds 3
    
    scoop update
}

function InstallApps {

    Clear-Host

    Write-Host "Instalando aplicações para o dia a dia." -ForegroundColor DarkCyan
    Start-Sleep -Seconds 3

    $DEFAULT_APPS = @(
        "extras/dbeaver",
        "extras/lens",
        "extras/notepadplusplus",
        "extras/posh-git",
        "extras/postman",
        "extras/powertoys",
        "extras/psreadline",
        "extras/soapui",
        "extras/terminal-icons",
        "extras/vscode",
        "main/7zip",
        "main/aws",
        "main/azure-cli",
        "main/eza",
        "main/git",
        "main/go",
        "main/golangci-lint",
        "main/helix",
        "main/k9s",
        "main/kubecolor",
        "main/kubectl",
        "main/powershell-yaml",
        "main/sqlite",
        "main/starship",
        "main/opentofu",
        "main/tenv",
        "main/terraform-ls",
        "main/tflint",
        "main/uv",
        "nerd-fonts/JetBrainsMono-NF",
        "nerd-fonts/JetBrainsMono-NF-Mono",
        "versions/dotnet-sdk-lts",
        "versions/windows-terminal-preview"
    )

    scoop update 

    foreach ($app in $DEFAULT_APPS) {
         Write-Host "Instalando $app..." -ForegroundColor Cyan
         scoop install $app
    }

}

function GoApps {
    go install github.com/air-verse/air@latest
    go install golang.org/x/tools/gopls@latest
    go install github.com/go-delve/delve/cmd/dlv@latest
    go install golang.org/x/tools/cmd/goimports@latest
    go install github.com/nametake/golangci-lint-langserver@latest
}

function InstallWsl {
    Clear-Host 
    Write-Host "
    Para configurar, preciso remover o Ubuntu atual
    e instalar novamente. Todos os dados seão perdidos (Y/N)" -ForegroundColor DarkCyan
    $select = Read-Host

    while ($select -ne "Y" )
    {
        Write-Host "Voce não concordou. Saindo..."
        Start-Sleep -Seconds 2
        return
    }

    wsl --unregister Ubuntu
    wsl --set-default-version 2

    Write-Host "Ubuntu no WSL2 removido" -ForegroundColor Darkcyan
    Start-Sleep -Seconds 2
    Clear-Host
    write-host "
    Quando a instalação terminar voce precisa inserir um nome de usuário
    e uma senha. Após criar digite exit, aperte enter e voltaremos ao powershell.
    Aperte qualquer tecla para continuar
 "  -ForegroundColor Darkcyan
    
    Read-Host

    wsl --install -d Ubuntu 

    Write-Host "WSL instalado com sucesso. "
}

function SyncConfig {
    
    write-host "Iniciando configuracao visual" -ForegroundColor DarkCyan
    Start-Sleep -Seconds 2

    if ( -Not (Test-Path "$PROFILE" )) {
        Write-Host "Criando arquivos" -ForegroundColor DarkGreen
        New-item -ItemType Directory -Path $HOME\Documents\WindowsPowerShell   
    }

    if ( -Not (Test-Path "$HOME\.config")) {
        write-host "Criando pasta .config em $HOME"
        New-Item -ItemType Directory -Path $HOME\config
    }

    # Porwershell profile 
    Copy-Item $HOME\.dotfiles\config\Microsoft.PowerShell_profile.ps1 -Destination $HOME\DOCUMENTS\WindowsPowerShell\ -Force
    # Powershell ISE Profile
    Copy-Item $HOME\.dotfiles\config\Microsoft.PowerShell_profile.ps1 -Destination $PROFILE -Force
    # Startship preset
    Copy-Item $HOME\.dotfiles\config\starship\starship.toml $HOME\.config\starship.toml
    # Helix Editor profile
    Copy-Item $HOME\.dotfiles\config\helix -Destination $Env:APPDATA\helix -Force -Recurse
 
}

function GitConfig {
    write-host "Escreva seu nome:"
    $nome = Read-Host

    write-host "Escreva seu email:"
    $email = Read-Host

    git config --global user.name $nome
    git config --global user.email $email

}

#############################
#  Aqui se inicia o script  #
#############################

SyncConfig # Copia arquivos de configuracao para .dotfiles no seu diretorio pessoal
InstallScoop # Install scoop
AddScoopButckets # Add repositorios para scoop como APT do ubuntu
InstallApps # Instala os aplicativos. 
GoApps 
GitConfig

write-host "Carrega novamente o perfil com as melhorias"
. $PROFILE 

if (IsAdmin) {
    InstallWsl # Intall Wsl for SRE - python - node - docker
}

Write-Host "Configuração realizado com sucesso. Aproveite" -ForegroundColor DarkCyan

