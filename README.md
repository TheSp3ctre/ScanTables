# AutoRecon

Salve galerinha, fiz uma ferramenta útil para Kali Linux/Kali Nethunter.. e para usar esta ferramenta:

1. Salve o script como `autorecon.sh`.
2. Torne-o executável: `chmod +x autorecon.sh`.
3. Execute-o como root: `sudo ./autorecon.sh`.


Faz o seguinte:

Checa se tá tudo certo com as dependências necessárias.
Pede um IP ou domínio pra você.
Confere se o que você digitou tá correto.
Cria uma pastinha pra guardar os resultados.
Usa o nmap pra escanear as portas.
Faz um scan de vulnerabilidades web com o nikto.
Usa o dirb pra tentar achar diretórios escondidos.
Descobre as tecnologias web do alvo com o whatweb.
Faz umas consultas DNS com o host e o dig.
Puxa as infos de WHOIS do alvo.
Junta tudo num relatório HTML bonitinho com os resultados.
Resumindo: é uma ferramenta pra coletar um monte de informações sobre um alvo 🫰
