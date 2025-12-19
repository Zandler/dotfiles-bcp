# Atalhos (ALIAS) para os principais comandos
 
## KUBECOLOR (Kubectl com cores)

| Alias | Comando                     | O que faz         | Exemplo      |
| ----- | --------------------------- | ----------------- | ------------ |
| `kgp` | `kubecolor get pods`        | Lista pods        | `kgp -n dev` |
| `kgs` | `kubecolor get services`    | Lista serviços    | `kgs -A`     |
| `kgd` | `kubecolor get deployments` | Lista deployments | `kgd -n api` |
| `kgn` | `kubecolor get nodes`       | Lista nodes       | `kgn`        |
| `kgi` | `kubecolor get ingress`     | Lista ingress     | `kgi -n web` |
| `kdp` | `kubecolor delete pod`        | Remove pod        | `kdp nginx-123` |
| `kdd` | `kubecolor delete deployment` | Remove deployment | `kdd web-api`   |
| `kds` | `kubecolor delete service`    | Remove service    | `kds redis`     |
| `ksp` | `kubecolor describe pod`        | Detalhes pod    | `ksp nginx` |
| `ksd` | `kubecolor describe deployment` | Detalhes deploy | `ksd api`   |
| `ksn` | `kubecolor describe node`       | Detalhes node   | `ksn node1` |
| `kcr` | `kubecolor create -f` | Cria recurso via YAML | `kcr app.yaml` |
| `ked` | `kubecolor edit deployment` | Edita deployment | `ked web`   |
| `kep` | `kubecolor edit pod`        | Edita pod        | `kep redis` |
| `krun` | `kubecolor run` | Executa workload | `krun busybox` |
| `kexec` | `kubecolor exec` | Executa comando em pod | `kexec nginx -- bash` |

## GIT 

| Alias   | Comando                        | O que faz               | Exemplo       |
| ------- | ------------------------------ | ----------------------- | ------------- |
| `ls`    | `eza ...`                      | Lista arquivos          | `ls`          |
| `ll`    | `eza --tree ...`               | Lista árvore            | `ll`          |
| `ga`    | `git add .`                    | Stage geral             | `ga`          |
| `gca`   | `git commit --amend`           | Reescreve último commit | `gca`         |
| `gco`   | `git checkout`                 | Muda branch             | `gco develop` |
| `gcob`  | `git checkout -b`              | Cria nova branch        | `gcob teste`  |
| `gs`    | `git status -sb`               | Status curto            | `gs`          |
| `gl`    | `git log --oneline`            | Log curto               | `gl`          |
| `glc`   | `git log -1 ...`               | Último commit           | `glc`         |
| `grb`   | `git branch -r -v`             | Branches remotas        | `grb`         |
| `gcm`   | `git commit -m`                | Commit simples          | `gcm "fix"`   |
| `glbm`  | `git for-each-ref ... heads`   | Lista branches locais   | `glbm`        |
| `glbmr` | `git for-each-ref ... remotes` | Lista branches remotas  | `glbmr`       |
