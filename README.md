# DOTFILES WINDOWS

### Requisitos
- Windows 11 com as ultimas atualizações
- Powershell na verão maior que 5

### Instruções:
Não é ncessário ser admin para quase nada, exceto instalar o WSL. Ele checa caso seja admin, instala wsl, caso contrário ele pula esse passo.

```powershell
 Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Iwr -Uri https://raw.githubusercontent.com/Zandler/dotfiles-bcp/refs/heads/main/install.ps1 -OutFile install.ps1; ./install.ps1
```
**O que é instalado?**
caso queira saber oq ue é instalado, abra o arquivo boostrap.ps1 e vá a linha 78. Entenda que aqui tem o que EU preciso e voce é livre para modificar e colocar de acordo co seu contexto.

O perfil terá uma série de atalhos para melhorar a produtividade no terminal. Caso queira ver esses atalhos, [CLIQUE AQUI](ALIAS.md)
