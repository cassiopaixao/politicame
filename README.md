PoliticaMe
==========

Projeto da página http://politica.me

# Descrição do projeto

O objetivo do PoliticaMe é ajudar um cidadão a encontrar candidatos que pensam
de maneira semelhante à dele. Para isso, o usuário vota a favor ou contra em
proposições votadas em plenário e acessa um ranking, que apresenta nas primeiras
posições os deputados que votaram de maneira mais semelhante à dele nas mesmas
proposições.

Com isso, o usuário pode acessar a página dos deputados de seu interesse e
obter mais informações sobre eles, como votos em proposições, presença em
sessões e notícias relacionadas ao mesmo.

A apresentação do PoliticaMe no 1º Hackathon da Câmara dos Deputados pode ser
visualizada em http://www.youtube.com/watch?v=XPeSlYp4WQk


# Instalação

## Pré-requisitos

O sistema está sendo desenvolvido em RubyOnRails.
É necessário que o Ruby 2.0, com o Rails 3.2.14, esteja instalado.
Para execução de scripts, é necessário que esteja instalado o Python 2.7.4 (ou
superior).
Um banco de dados MySQL deve estar configurado.


## Configuração do banco de dados

Copiados os arquivos para uma pasta (consideraremos "~/politicame"), copie
o arquivo ~/politicame/rails/politicame/config/database.yml.example para
~/politicame/rails/politicame/config/database.yml . Edite-o alterando os dados
para acesso ao banco de dados (note que há seções para configuração do banco
de dados em diferentes ambientes).


## Seed de dados: parte 1

$ cd ~/politicame/rails/politicame

$ bundle install

$ rake db:migrate

$ rake db:seed_fu


## Seed de dados: parte 2

Inicie o servidor:

$ cd ~/politicame/rails/politicame/

$ rails server

Nota: O modo de inicialização do servidor pode variar dependendo do modo como
instalou o ruby/rails.

Em um navegador, acesse http://localhost:3000/importacao/importar_deputados.
A página exibirá alguns dados dos deputados recuperados do serviço de dados
abertos da Câmara. Clique no botão "Atualizar deputados" para atualizar as
informações dos deputados no banco de dados.


## Seed de dados: parte 3

$ cd ~/politicame/python

Execute os scripts presenca.py e twitter_parser.py de acordo com as instruções
nas seções seguintes.


### Script para baixar dados sobre as frequências dos deputados federais às sessões

Script: presenca.py

Linguagem: Python

Uso: python presenca.py {endereço do banco de dados (bd)} {usuário do bd} {senha do bd} {nome do bd} {data de início} {data de fim}

Esse script foi desenvolvido em Python e está na pasta python/, com o nome
presenca.py. O script utiliza o WebService
http://www.camara.gov.br/SitCamaraWS/sessoesreunioes.asmx/ListarPresencasParlamentar
para baixar os dados da frequência de cada deputado.

O script recebe, por meio de argumentos, como entrada informações sobre o banco
de dados onde está a tabela com os registros dos deputados e data de início e
fim da sessões das quais se deseja pegar informações sobre a frequência de cada
deputado. Fazendo então a contagem das sessões que cada deputado se fez presente
ou faltou, o script atualiza a tabela presenca_sessaos.


### Script para pegar os endereços das contas de twitter de cada deputado

Script: twitter_parser.py

Linguagem: Python

Uso: python twitter_parser.py < twitters.txt

O twitter_parser.py recebe por meio da entrada padrão uma lista formatada com
os nomes de deputados e seus twitters. O arquivo twitters.txt foi criado a partir
da página
http://blogdosakamoto.blogosfera.uol.com.br/2012/05/03/veja-a-lista-dos-enderecos-dos-deputados-no-twitter/.

O formato do arquivo twitters.txt segue o seguinte padrão para cada linha:

{NOME DO PARLAMENTAR}   {PARTIDO}   {ESTADO}    {ENDEREÇO DA CONTA DO TWITTER}

Onde cada coluna é separada por uma tabulação. O script imprime o SQL com as inserções na tabela.
Esse SQL deve ser executado no banco de dados da aplicação.


## Seed de dados: parte 4

Com o servidor inicializado, acesse http://localhost:3000/importacao/proposicoes.
Defina um período para busca de proposições, certifique-se que a caixa "Recuperar
votações relacionadas" e clique em "Buscar proposições desse período".

O sistema irá buscar no serviço de dados abertos da Câmara dos Deputados os
PLs, PLCs, PLNs, PLPs, PLSs, PECs e MPVs apreseentados nesse período, bem como
as votações que ocorreram dessas proposições. (Observe que será realizada uma
requisição para cada proposição desse período, assim, o período de busca
influenciará muito no tempo de execução dessa operação.)

Acesse http://localhost:3000/importacao/set_masters. Nessa página são exibidas
as proposições que tiveram pelo menos uma votação. Dado o teor das votações,
selecione as que aprovam ou reprovam as referidas proposições. Ao clicar em
"Confirmar votações master", o sistema irá buscar e adicionar ao banco os
votos dos deputados nessas votações, bem como disponibilizar as referidas
proposições para votação pelos usuários.
