
Contribuicao.seed(:autor, :rotulo, :proposicao_id) do |s|
  proposicao = Proposicao.where(tipo: 'PEC', numero: '37', ano: '2011').first
  if proposicao.present?
    s.proposicao_id = proposicao.id
    s.autor = 'Votenaweb'
    s.fonte = 'http://www.votenaweb.com.br/projetos/pec-37-2011'
    s.rotulo = 'Votenaweb'
    s.conteudo = <<-HTML
    <p><strong>Sumário:</strong></p>
    <p>
      Proibirá o Ministério Público de investigar e apurar crimes, estabelecendo que apenas a polícia federal e a polícia civil poderão investigar.
    </p>
    <p><strong>Resumo:</strong></p>
    <p>
      Esta proposta de emenda à Constituição estabelece que apenas a polícia federal e as polícias civis dos Estados e do Distrito Federal poderão:
    </p>
      <ul>
        <li>investigar crimes contra a ordem política e social ou em prejuízo de bens, serviços e interesses da União ou de suas entidades públicas, assim como outros crimes que tenham repercussão interestadual ou internacional;</li>
        <li>prevenir e reprimir o tráfico ilícito de drogas, o contrabando e o descaminho;</li>
        <li>exercer as funções de polícia marítima, aeroportuária e de fronteiras;</li>
        <li>exercer, com exclusividade, as funções de polícia judiciária da União;</li>
        <li>exercer funções de polícia judiciária, além de investigar e apurar crimes, desde que não sejam crimes militares. Dessa forma, o Ministério Público não poderá investigar e apurar estes crimes.</li>
      </ul>
    <p>
      Segundo o deputado, a investigação realizada pela policia (inquérito policial) é o único instrumento capaz de obter todos os elementos e indícios necessários para a realização da justiça, além de sofrer o controle do juiz e do Ministério Público, gerando segurança na investigação. Já as investigações realizadas por outros órgãos causam muitos problemas, pois são procedimentos informais, sem prazo, sem forma e sem controle. Sendo assim, é necessário restringir o poder de investigação de crimes apenas às polícias federal e civil.
    </p>
HTML
  end
end


Contribuicao.seed(:autor, :rotulo, :proposicao_id) do |s|
  proposicao = Proposicao.where(tipo: 'PEC', numero: '478', ano: '2010').first
  if proposicao.present?
    s.proposicao_id = proposicao.id
    s.autor = 'Votenaweb'
    s.fonte = 'http://www.votenaweb.com.br/projetos/pec-478-2010‎'
    s.rotulo = 'Votenaweb'
    s.conteudo = <<-HTML
    <p><strong>Sumário:</strong></p>
    <p>
      Garantirá aos empregados domésticos os mesmos direitos que possuem os demais trabalhadores.
    </p>
    <p><strong>Resumo:</strong></p>
    <p>
      O projeto propõe a igualdade de direitos trabalhistas entre empregados domésticos e demais trabalhadores de instituições publicas e privadas. Para tanto, deve ser anulado o parágrafo da Constituição Federal que anuncia a totalidade dos direitos dos trabalhadores. Esse parágrafo limita tais direitos apenas aos ‘trabalhadores urbanos e rurais’, o que exclui o grupo dos empregados domésticos. Portanto, trata-se de um ajuste no texto da Constituição que objetiva a inclusão dos direitos trabalhistas aos empregados domésticos.
    </p><p>
      Segundo o deputado, esse parágrafo da Constituição Federal é motivo de vergonha. Ainda que ocorra o aumento das despesas para se manter o empregado, não é justificável que se mantenha tal desnível entre diferentes grupos de trabalhadores. Essa mudança no texto garantirá aos trabalhadores domésticos o acesso aos direitos trabalhistas, tais como FGTS, Seguro Desemprego, pagamento de horas extrais e benefício previdenciário por acidente de trabalho.
    </p>
HTML
  end
end

Contribuicao.seed(:autor, :rotulo, :proposicao_id) do |s|
  proposicao = Proposicao.where(tipo: 'PLC', numero: '4470', ano: '2012').first
  if proposicao.present?
    s.proposicao_id = proposicao.id
    s.autor = 'VoteNaWeb'
    s.fonte = 'http://www.votenaweb.com.br/projetos/plc-4470-2012‎'
    s.rotulo = 'VoteNaWeb'
    s.conteudo = <<-HTML
    <p><strong>Sumário:</strong></p>
    <p>
      Proibirá o Ministério Público de investigar e apurar crimes, estabelecendo que apenas a polícia federal e a polícia civil poderão investigar.
    </p>
    <p><strong>Resumo:</strong></p>
    <p>
      Este projeto de lei determinará que quando um político mudar de partido, os votos conquistados por ele na última eleição não poderão ser levados para o novo partido dele. Dessa forma, quando um político mudar para um partido novo, que acabou de ser criado, os votos obtidos por ele não beneficiarão o novo partido no ratio das verbas e do tempo de propaganda no rádio e TV.
    </p><p>
      Pela legislação atual, quando um político muda de partido ele leva o número de votos conquistados por ele para a nova legenda, e esse número influencia na divisão das verbas eleitorais e no tempo de propaganda em rádio e TV que os partidos têm direito.
    </p><p>
      Para as verbas eleitorais, são usados recursos do Fundo Partidário. De todo o valor, 5% são distribuídos de forma igualitária entre todos os partidos, e os demais 95% são distribuídos de forma proporcional de acordo com os votos recebidos na eleição para a Câmara dos Deputados.
    </p><p>
      No tempo de rádio e TV, 1/3 é distribuído igualmente e os demais 2/3 são proporcionais também, dependendo dos votos recebidos para a Câmara dos Deputados.
    </p><p>
      Segundo o deputado, existe hoje uma insegurança jurídica sobre a forma de distribuição proporcional, pois não trata das migrações partidárias ocorridas durante o mandato. Assim, não sabem como será a distribuição até o fim das legislaturas. A ideia, segundo o autor do projeto, é impedir que as mudanças de partido (mesmo que para novos partidos) interfira nas verbas partidárias e nos tempos de rádio e TV.
    </p>
HTML
  end
end
