# ScanTables

Este projeto bem básico permite analisar e exibir de forma organizada os resultados gerados pelo Nmap em formato XML. Abaixo estão os passos para instalar e usar a ferramenta.

## Passos para Uso

### 1. Instalar a gem `nokogiri`:

```(\`\`\`bash\`) gem install nokogiri ```

### Executar um scan do Nmap e salvar a saída em formato XML:
``` nmap -oX output.xml [alvo] ``` 

### Modificar a última linha do script para apontar para o seu arquivo XML: 

``` parser = NmapParser.new('caminho/para/seu/arquivo.xml') ```

Substitua ```caminho/para/seu/arquivo.xml``` pelo caminho correto do seu arquivo XML gerado pelo Nmap, belezinha? 

### E finalmente, executar o script:

``` ruby nmap_parser.rb ```

Isso vai processar o arquivo XML e exibir os resultados no terminal. 
