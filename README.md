# 🏥 Painel de Autoatendimento - TI Hospitalar

Uma interface gráfica (GUI) nativa em PowerShell desenvolvida para centralizar e automatizar a resolução de problemas técnicos comuns em computadores hospitalares. O objetivo principal é capacitar usuários leigos (médicos, enfermeiros e recepcionistas) a resolverem falhas simples de forma autônoma, reduzindo a fila de chamados de baixa complexidade da equipe de TI.

---

## 🚀 Funcionalidades (As 10 Ferramentas)

O painel foi projetado com uma interface limpa, botões grandes e mensagens amigáveis que rodam comandos do sistema em segundo plano:

1. **Corrigir Internet:** Renova o endereço IP da máquina (`release/renew`) para reestabelecer conexões perdidas.
2. **Limpar Memória de Sites:** Executa o *Flush DNS* para resolver problemas de sistemas web que não carregam.
3. **DNS Automático:** Remove configurações manuais antigas e força o adaptador a buscar o DNS via DHCP.
4. **Destravar Impressora:** Para o serviço de Spooler, limpa os arquivos corrompidos da fila de impressão e reinicia o serviço. **(Campeão de chamados)**.
5. **Atualizar Permissões:** Força a atualização das diretivas de grupo (`gpupdate /force`) com o servidor do hospital.
6. **Limpar Arquivos Temps:** Apaga caches e arquivos temporários das pastas do sistema para liberar espaço em disco.
7. **Esvaziar Lixeira:** Limpa a lixeira do Windows de forma definitiva sem exigir navegação do usuário.
8. **Meus Dados (Chamar TI):** Exibe em letras grandes o **Nome do Computador** e o **IP Atual**, facilitando a identificação caso o usuário precise ligar para o ramal da TI.
9. **Testar Conexão Sistema:** Faz um ping rápido no servidor central do prontuário eletrônico e retorna um diagnóstico visual (Sucesso ou Falha).
10. **Reiniciar Computador:** Força uma reinicialização limpa (`shutdown /r /f`), contornando a hibernação do *Fast Startup* do Windows.

---

## 🎨 Interface Visual

*   **Design Responsivo e Familiar:** Construído utilizando a biblioteca nativa `System.Windows.Forms`.
*   **Experiência de Usuário (UX):** Janela com tamanho fixo, efeito *hover* nos botões e ocultação total de telas pretas de terminal (CMD) para não assustar o usuário clínico.

---

## 🔧 Como Executar (Ambiente de Testes)

Por ser desenvolvido em PowerShell nativo, o projeto **não necessita da instalação de nenhuma dependência** (como Python ou Node.js).

1. Baixe o arquivo `PainelSuporte.ps1`.
2. Abra o PowerShell como **Administrador**.
3. Permita a execução de scripts na sua sessão atual executando:
```powershell
   Set-ExecutionPolicy Unrestricted -Scope Process -Force
```


| Código da Função | Nome na Interface (Botão) | Comando Executado em Segundo Plano | Problema Resolvido no Hospital | Impacto / Benefício |
| :---: | :--- | :--- | :--- | :--- |
| **01** | `1. Corrigir Internet` | `ipconfig /release` <br> `ipconfig /renew` | PC perdeu o IP correto ou está com conectividade nula/limitada na rede local. | Restaura o sinal de rede e internet sem reiniciar o computador. |
| **02** | `2. Limpar Memória de Sites` | `ipconfig /flushdns` | Sistemas web do hospital (prontuário, laudos) não carregam após atualizações no servidor. | Limpa o cache de DNS, forçando o navegador a buscar o endereço IP mais recente do sistema. |
| **03** | `3. DNS Automático` | `netsh interface ip set dns name="Ethernet" source=dhcp` | Máquina estática ou modificada manualmente por engano, bloqueando o acesso à rede interna. | Força a placa de rede a obter o DNS corporativo correto diretamente do servidor DHCP. |
| **04** | `4. Destravar Impressora` | `net stop spooler` <br> `del /f /q %systemroot%\System32\Spool\Printers\*` <br> `net start spooler` | Documentos acumulados na fila de impressão travando as receitas ou etiquetas de setores críticos. | Limpa a fila corrompida e reinicia o serviço de impressão. **(Campeão de chamados do hospital)**. |
| **05** | `5. Atualizar Permissões` | `gpupdate /force` | Usuário mudou de setor, ou novas políticas/mapeamentos de rede precisam ser aplicados na hora. | Sincroniza o computador imediatamente com as novas regras e acessos do Active Directory (AD). |
| **06** | `6. Limpar Arquivos Temps` | `Remove-Item "$env:TEMP\*"` <br> `Remove-Item "C:\Windows\Temp\*"` | Lentidão geral no sistema causada pelo acúmulo de cache e falta de espaço em disco em PCs antigos. | Elimina arquivos residuais que poluem o armazenamento, melhorando o desempenho da máquina. |
| **07** | `7. Esvaziar Lixeira` | `Clear-RecycleBin -Confirm:$false` | Discos rígidos cheios (especialmente em recepções) devido a PDFs e relatórios deletados mas não eliminados. | Libera espaço físico em disco de forma definitiva e imediata, com apenas um clique. |
| **08** | `8. Meus Dados (Chamar TI)` | `hostname` <br> `Get-NetIPAddress` | O usuário abre o chamado por telefone mas não sabe dizer o nome da máquina ou o IP para o acesso remoto. | Exibe de forma clara e visível na tela os dados de identificação do PC para repassar ao técnico. |
| **09** | `9. Testar Conexão Sistema` | `Test-Connection -ComputerName [IP_Servidor] -Count 2` | Incerteza se a lentidão/queda é do computador local ou se o servidor do Prontuário Eletrônico (PEP) caiu. | Realiza um diagnóstico em tempo real, informando visualmente ao usuário se o servidor está online. |
| **10** | `10. REINICIAR COMPUTADOR` | `shutdown /r /f /t 0` | Travamentos crônicos no Windows devido ao "Fast Startup" (recurso que hiberna o kernel e mantém bugs ativos). | Força o fechamento completo de todas as aplicações e realiza um boot 100% limpo na memória RAM. |
