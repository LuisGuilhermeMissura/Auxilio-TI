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
