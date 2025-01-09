# AutoRecon

Salve galerinha, fiz uma ferramenta útil para Kali Linux.. e para usar esta ferramenta:

1. Salve o script como `autorecon.sh`.
2. Torne-o executável: `chmod +x autorecon.sh`.
3. Execute-o como root: `sudo ./autorecon.sh`.


E oq esssa ferramenta faz?

1. Verifica se todas as dependências necessárias estão instaladas.
2. Solicita ao usuário um endereço IP ou nome de domínio alvo.
3. Valida a entrada do usuário.
4. Cria um diretório para armazenar os resultados.
5. Realiza uma varredura de portas usando nmap.
6. Executa uma varredura de vulnerabilidades web usando nikto.
7. Realiza uma força bruta de diretórios usando dirb.
8. Coleta informações sobre tecnologias web usando whatweb.
9. Realiza enumeração DNS usando host e dig.
10. Coleta informações WHOIS.
11. Gera um relatório HTML consolidando todos os resultados.
