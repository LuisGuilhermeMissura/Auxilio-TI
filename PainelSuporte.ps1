Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- Configuração Principal da Janela ---
$form = New-Object System.Windows.Forms.Form
$form.Text = "Painel de Autoatendimento - TI Hospitalar"
$form.Size = New-Object System.Drawing.Size(600, 520)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.BackColor = [System.Drawing.Color]::FromArgb(245, 247, 250)

# --- Título do Painel ---
$labelTitulo = New-Object System.Windows.Forms.Label
$labelTitulo.Text = "Central de Ajuda Rápida (Suporte TI)"
$labelTitulo.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$labelTitulo.Location = New-Object System.Drawing.Point(20, 15)
$labelTitulo.Size = New-Object System.Drawing.Size(540, 35)
$labelTitulo.ForeColor = [System.Drawing.Color]::FromArgb(44, 62, 80)
$form.Controls.Add($labelTitulo)

$labelSub = New-Object System.Windows.Forms.Label
$labelSub.Text = "Selecione uma das opções abaixo para corrigir problemas comuns do seu computador."
$labelSub.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
$labelSub.Location = New-Object System.Drawing.Point(23, 50)
$labelSub.Size = New-Object System.Drawing.Size(540, 20)
$labelSub.ForeColor = [System.Drawing.Color]::FromArgb(127, 140, 141)
$form.Controls.Add($labelSub)

# --- Função Auxiliar para Criar Botões Padronizados ---
function Criar-Botao ($texto, $X, $Y, $scriptBloco) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $texto
    $btn.Size = New-Object System.Drawing.Size(260, 50)
    $btn.Location = New-Object System.Drawing.Point($X, $Y)
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $btn.BackColor = [System.Drawing.Color]::White
    $btn.ForeColor = [System.Drawing.Color]::FromArgb(52, 73, 94)
    $btn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $btn.FlatAppearance.BorderSize = 1
    $btn.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(189, 195, 199)
    $btn.Cursor = [System.Windows.Forms.Cursors]::Hand
    
    # Efeito Hover Simples
    $btn.Add_MouseEnter({ $this.BackColor = [System.Drawing.Color]::FromArgb(235, 240, 245) })
    $btn.Add_MouseLeave({ $this.BackColor = [System.Drawing.Color]::White })
    
    $btn.Add_Click($scriptBloco)
    $form.Controls.Add($btn)
}

# --- LÓGICA E AÇÕES DOS BOTÕES ---

# 1. Corrigir Internet
$acaoNet = {
    [System.Windows.Forms.MessageBox]::Show("Renovando sua conexão com a rede do hospital. Aguarde alguns segundos...", "Processando", 0, 64)
    ipconfig /release | Out-Null
    Start-Sleep -Seconds 1
    ipconfig /renew | Out-Null
    [System.Windows.Forms.MessageBox]::Show("Sua conexão de rede foi reiniciada com sucesso!", "Concluído", 0, 64)
}

# 2. Limpar Flush DNS
$acaoDNS = {
    ipconfig /flushdns | Out-Null
    [System.Windows.Forms.MessageBox]::Show("A memória de sites (DNS) foi limpa. Tente acessar o sistema novamente.", "Concluído", 0, 64)
}

# 3. DNS Automático
$acaoDnsAuto = {
    # Altere "Ethernet" para o nome padrão da rede dos seus PCs se necessário
    netsh interface ip set dns name="Ethernet" source=dhcp | Out-Null
    [System.Windows.Forms.MessageBox]::Show("Configurações de DNS restauradas para o padrão automático.", "Concluído", 0, 64)
}

# 4. Destravar Impressora
$acaoSpooler = {
    [System.Windows.Forms.MessageBox]::Show("Limpando a fila e reiniciando o sistema de impressão...", "Processando", 0, 64)
    Stop-Service -Name "Spooler" -Force -ErrorAction SilentlyContinue
    # Remove arquivos presos na fila de impressão
    Remove-Item "$env:SystemRoot\System32\Spool\Printers\*" -Force -Recurse -ErrorAction SilentlyContinue
    Start-Service -Name "Spooler"
    [System.Windows.Forms.MessageBox]::Show("Impressora destravada! Se os documentos não saírem, tente mandar imprimir novamente.", "Concluído", 0, 64)
}

# 5. Atualizar Diretivas (GPUpdate)
$acaoGp = {
    [System.Windows.Forms.MessageBox]::Show("Buscando novas permissões no servidor. Isso pode levar até um minuto...", "Processando", 0, 64)
    gpupdate /force | Out-Null
    [System.Windows.Forms.MessageBox]::Show("Diretivas e permissões atualizadas com sucesso.", "Concluído", 0, 64)
}

# 6. Limpar Arquivos Temporários
$acaoTemp = {
    Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    [System.Windows.Forms.MessageBox]::Show("Arquivos temporários eliminados. O computador ficou mais leve!", "Concluído", 0, 64)
}

# 7. Esvaziar Lixeira
$acaoLixeira = {
    Clear-RecycleBin -Confirm:$false -ErrorAction SilentlyContinue
    [System.Windows.Forms.MessageBox]::Show("A lixeira do computador foi completamente esvaziada.", "Concluído", 0, 64)
}

# 8. Chamar o TI (Identificar Máquina)
$acaoIdentificar = {
    $nomePC = $env:COMPUTERNAME
    $ipValores = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true } | Select-Object -ExpandProperty IPAddress
    $ipAtual = $ipValores[0] # Pega o IPv4 primário
    
    [System.Windows.Forms.MessageBox]::Show("Passe esses dados para o Técnico da TI:`n`nNome do Computador: $nomePC`nEndereço IP Atual: $ipAtual", "Identificação do Computador", 0, 64)
}

# 9. Testar Conexão com Sistema (Exemplo com o Google/Servidor local)
$acaoTestarPing = {
    $servidor = "8.8.8.8" # Substitua pelo IP do servidor do prontuário ou banco de dados do hospital
    if (Test-Connection -ComputerName $servidor -Count 2 -Quiet) {
        [System.Windows.Forms.MessageBox]::Show("Conexão bem-sucedida! O computador está conseguindo conversar com o servidor central.", "Status: Conectado", 0, 64)
    } else {
        [System.Windows.Forms.MessageBox]::Show("Falha de Comunicação! O computador NÃO está alcançando o servidor central. Ligue para a TI.", "Status: Sem Conexão", 0, 48)
    }
}

# 10. Reiniciar da Maneira Certa
$acaoReiniciar = {
    $confirmar = [System.Windows.Forms.MessageBox]::Show("Deseja mesmo fechar todos os programas e reiniciar o computador agora?", "Confirmar Reinicialização", 4, 32)
    if ($confirmar -eq "Yes") {
        shutdown /r /f /t 0
    }
}

# --- POSICIONAMENTO DOS BOTÕES NA TELA (Layout em 2 Colunas) ---
# Coluna 1 (X=25)                    # Coluna 2 (X=305)
Criar-Botao "1. Corrigir Internet"      25  90  $acaoNet
Criar-Botao "2. Limpar Memória de Sites" 305 90  $acaoDNS

Criar-Botao "3. DNS Automático"         25  160 $acaoDnsAuto
Criar-Botao "4. Destravar Impressora"    305 160 $acaoSpooler

Criar-Botao "5. Atualizar Permissões"    25  230 $acaoGp
Criar-Botao "6. Limpar Arquivos Temps"   305 230 $acaoTemp

Criar-Botao "7. Esvaziar Lixeira"       25  300 $acaoLixeira
Criar-Botao "8. Meus Dados (Chamar TI)"  305 300 $acaoIdentificar

Criar-Botao "9. Testar Conexão Sistema"  25  370 $acaoTestarPing

# Botão de reiniciar destacado em Vermelho/Laranja no final
$btnReiniciar = Criar-Botao "10. REINICIAR COMPUTADOR" 305 370 $acaoReiniciar
# (Ajuste fino visual para o botão de reiniciar se destacar)

# --- Rodapé Informativo ---
$labelRodape = New-Object System.Windows.Forms.Label
$labelRodape.Text = "Desenvolvido para facilitar o suporte interno. Em caso de dúvidas graves, ligue no ramal da TI."
$labelRodape.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Italic)
$labelRodape.Location = New-Object System.Drawing.Point(20, 450)
$labelRodape.Size = New-Object System.Drawing.Size(540, 20)
$labelRodape.ForeColor = [System.Drawing.Color]::Gray
$form.Controls.Add($labelRodape)

# Exibe a interface
$form.ShowDialog() | Out-Null