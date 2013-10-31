politicame
==========

Projeto da página politica.me

# Instalação

## Script para baixar dados sobre as frequências dos deputados federais às sessões

Script: presenca.py
Linguagem: Python
Uso: python presenca.py <endereço do banco de dados (bd)> <usuário do bd> <senha do bd> <nome do bd> <data de início> <data de fim>

Esse script foi desenvolvido em Python e está na pasta python/, com o nome presenca.py. O script utiliza o WebService http://www.camara.gov.br/SitCamaraWS/sessoesreunioes.asmx/ListarPresencasParlamentar para baixar os dados da frequência de cada deputado.

O script recebe, por meio de argumentos, como entrada informações sobre o banco de dados onde está a tabela com os registros dos deputados e data de início e fim da sessões das quais se deseja pegar informações sobre a frequência de cada deputado. Fazendo então a contagem das sessões que cada deputado se fez presente ou faltou, o script atualiza a tabela presenca_sessaos.

## Script para pegar os endereços das contas de twitter de cada deputado

Script: twitter_parser.py
Linguagem: Python
Uso: python twitter_parser.py < twitters.txt

O twitter_parser.py recebe por meio da entrada padrão uma lista formatada com os nomes de deputados e seus twitters. O arquivo twitters.txt foi criado a partir da página http://blogdosakamoto.blogosfera.uol.com.br/2012/05/03/veja-a-lista-dos-enderecos-dos-deputados-no-twitter/.

O formato do arquivo twitters.txt segue o seguinte padrão para cada linha:

<NOME DO PARLAMENTAR>	<PARTIDO>	<ESTADO>	<ENDEREÇO DA CONTA DO TWITTER>

Onde cada coluna é separada por uma tabulação. O script imprime o SQL com as inserções na tabela.