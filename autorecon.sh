#!/bin/bash

# AutoRecon v1.0
# Scanner Automatizado de Reconhecimento e Vulnerabilidades Básicas para Kali Linux
# Copyright 2025 SecureTech

# Cores para saída
VERMELHO='\033[0;31m'
VERDE='\033[0;32m'
AMARELO='\033[1;33m'
SC='\033[0m' # Sem Cor

# Verifica se o script está sendo executado como root
if [[ $EUID -ne 0 ]]; then
   echo -e "${VERMELHO}Este script deve ser executado como root${SC}" 
   exit 1
fi

# Função para verificar se as ferramentas necessárias estão instaladas
verificar_dependencias() {
    local deps=("nmap" "nikto" "dirb" "whatweb" "whois" "host" "dig")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo -e "${VERMELHO}Erro: $dep não está instalado. Por favor, instale-o e tente novamente.${SC}"
            exit 1
        fi
    done
}

# Função para validar endereço IP
validar_ip() {
    local ip=$1
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        IFS='.' read -r -a ip_array <<< "$ip"
        for octet in "${ip_array[@]}"; do
            if [[ $octet -lt 0 || $octet -gt 255 ]]; then
                return 1
            fi
        done
        return 0
    else
        return 1
    fi
}

# Função para validar nome de domínio
validar_dominio() {
    local dominio=$1
    if [[ $dominio =~ ^[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}$ ]]; then
        return 0
    else
        return 1
    fi
}

# Função para realizar varredura de portas
varredura_portas() {
    local alvo=$1
    local dir_saida=$2
    echo -e "${AMARELO}[*] Iniciando varredura de portas...${SC}"
    nmap -sV -sC -O -oN "$dir_saida/varredura_nmap.txt" "$alvo"
    echo -e "${VERDE}[+] Varredura de portas concluída. Resultados salvos em $dir_saida/varredura_nmap.txt${SC}"
}

# Função para realizar varredura de vulnerabilidades web
varredura_web() {
    local alvo=$1
    local dir_saida=$2
    echo -e "${AMARELO}[*] Iniciando varredura de vulnerabilidades web...${SC}"
    nikto -h "$alvo" -o "$dir_saida/varredura_nikto.txt"
    echo -e "${VERDE}[+] Varredura de vulnerabilidades web concluída. Resultados salvos em $dir_saida/varredura_nikto.txt${SC}"
}

# Função para realizar força bruta de diretórios
forca_bruta_dir() {
    local alvo=$1
    local dir_saida=$2
    echo -e "${AMARELO}[*] Iniciando força bruta de diretórios...${SC}"
    dirb "http://$alvo" -o "$dir_saida/varredura_dirb.txt" -r
    echo -e "${VERDE}[+] Força bruta de diretórios concluída. Resultados salvos em $dir_saida/varredura_dirb.txt${SC}"
}

# Função para coletar informações sobre tecnologias web
info_tech_web() {
    local alvo=$1
    local dir_saida=$2
    echo -e "${AMARELO}[*] Coletando informações sobre tecnologias web...${SC}"
    whatweb -v -a 3 "$alvo" > "$dir_saida/varredura_whatweb.txt"
    echo -e "${VERDE}[+] Informações sobre tecnologias web coletadas. Resultados salvos em $dir_saida/varredura_whatweb.txt${SC}"
}

# Função para realizar enumeração DNS
enum_dns() {
    local alvo=$1
    local dir_saida=$2
    echo -e "${AMARELO}[*] Realizando enumeração DNS...${SC}"
    host -a "$alvo" > "$dir_saida/varredura_host.txt"
    dig "$alvo" ANY +noall +answer >> "$dir_saida/varredura_dig.txt"
    echo -e "${VERDE}[+] Enumeração DNS concluída. Resultados salvos em $dir_saida/varredura_host.txt e $dir_saida/varredura_dig.txt${SC}"
}

# Função para coletar informações WHOIS
info_whois() {
    local alvo=$1
    local dir_saida=$2
    echo -e "${AMARELO}[*] Coletando informações WHOIS...${SC}"
    whois "$alvo" > "$dir_saida/info_whois.txt"
    echo -e "${VERDE}[+] Informações WHOIS coletadas. Resultados salvos em $dir_saida/info_whois.txt${SC}"
}

# Função para gerar relatório HTML
gerar_relatorio() {
    local alvo=$1
    local dir_saida=$2
    local arquivo_relatorio="$dir_saida/relatorio.html"
    
    echo -e "${AMARELO}[*] Gerando relatório HTML...${SC}"
    
    cat << EOF > "$arquivo_relatorio"
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Relatório AutoRecon para $alvo</title>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 800px; margin: 0 auto; padding: 20px; }
        h1, h2 { color: #2c3e50; }
        pre { background-color: #f4f4f4; padding: 15px; border-radius: 5px; overflow-x: auto; }
    </style>
</head>
<body>
    <h1>Relatório AutoRecon para $alvo</h1>
    <p>Varredura realizada em $(date)</p>
    
    <h2>Resultados da Varredura de Portas</h2>
    <pre>$(cat "$dir_saida/varredura_nmap.txt")</pre>
    
    <h2>Resultados da Varredura de Vulnerabilidades Web</h2>
    <pre>$(cat "$dir_saida/varredura_nikto.txt")</pre>
    
    <h2>Resultados da Força Bruta de Diretórios</h2>
    <pre>$(cat "$dir_saida/varredura_dirb.txt")</pre>
    
    <h2>Informações sobre Tecnologias Web</h2>
    <pre>$(cat "$dir_saida/varredura_whatweb.txt")</pre>
    
    <h2>Resultados da Enumeração DNS</h2>
    <h3>Host</h3>
    <pre>$(cat "$dir_saida/varredura_host.txt")</pre>
    <h3>Dig</h3>
    <pre>$(cat "$dir_saida/varredura_dig.txt")</pre>
    
    <h2>Informações WHOIS</h2>
    <pre>$(cat "$dir_saida/info_whois.txt")</pre>
</body>
</html>
EOF

    echo -e "${VERDE}[+] Relatório HTML gerado. Arquivo: $arquivo_relatorio${SC}"
}

# Função principal
principal() {
    verificar_dependencias

    echo -e "${VERDE}Bem-vindo ao AutoRecon - Ferramenta Automatizada de Reconhecimento${SC}"
    echo -e "${AMARELO}Por favor, insira o endereço IP ou nome de domínio alvo:${SC}"
    read -r alvo

    if validar_ip "$alvo"; then
        echo -e "${VERDE}Endereço IP válido inserido.${SC}"
    elif validar_dominio "$alvo"; then
        echo -e "${VERDE}Nome de domínio válido inserido.${SC}"
    else
        echo -e "${VERMELHO}Entrada inválida. Por favor, insira um endereço IP ou nome de domínio válido.${SC}"
        exit 1
    fi

    timestamp=$(date +%Y%m%d_%H%M%S)
    dir_saida="autorecon_${alvo}_${timestamp}"
    mkdir -p "$dir_saida"

    echo -e "${VERDE}[+] Iniciando reconhecimento em $alvo${SC}"
    echo -e "${VERDE}[+] Os resultados serão salvos em $dir_saida${SC}"

    varredura_portas "$alvo" "$dir_saida"
    varredura_web "$alvo" "$dir_saida"
    forca_bruta_dir "$alvo" "$dir_saida"
    info_tech_web "$alvo" "$dir_saida"
    enum_dns "$alvo" "$dir_saida"
    info_whois "$alvo" "$dir_saida"
    gerar_relatorio "$alvo" "$dir_saida"

    echo -e "${VERDE}[+] Reconhecimento concluído. Os resultados estão salvos em $dir_saida${SC}"
    echo -e "${VERDE}[+] Relatório HTML gerado: $dir_saida/relatorio.html${SC}"
}

# Executa a função principal
principal