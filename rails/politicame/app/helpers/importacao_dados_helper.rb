module ImportacaoDadosHelper
  require 'net/http'
  require 'uri'
  require 'nokogiri'
  require 'open-uri'

  def buscar_proposicoes(initial_date, end_date, type)

    if !initial_date.is_a? Date or !end_date.is_a? Date or !type.is_a? String
      raise 'Invalid parameters'
    end

    host = 'http://www.camara.gov.br'
    path = '/SitCamaraWS/Proposicoes.asmx/ListarProposicoes'
    url = host + path

    params_listar_proposicoes = {
      :sigla => '',
      :numero => '',
      :ano => '',
      :datApresentacaoIni => '',
      :datApresentacaoFim => '',
      :autor => '',
      :parteNomeAutor => '',
      :siglaPartidoAutor => '',
      :siglaUFAutor => '',
      :generoAutor => '',
      :codEstado => '',
      :codOrgaoEstado => '',
      :emTramitacao => ''
    }

    as_hash = params_listar_proposicoes.merge({
      :datApresentacaoIni => initial_date.strftime('%d/%m/%Y'),
      :datApresentacaoFim => end_date.strftime('%d/%m/%Y'),
      :sigla => type,
      :ano => initial_date.year
    })
    as_arr = []
    as_hash.each_pair do |k,v|
      as_arr << "#{k.to_s}=#{v.to_s}"
    end
    as_str = as_arr.join '&'

    request = Net::HTTP::Post.new(url)
    request.add_field 'Content-Type', 'application/x-www-form-urlencoded'
    request.add_field 'Accept', 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    # TODO parametrizar User-Agent
    request.add_field 'User-Agent', 'Politica.Me'
    request.body = as_str

    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.request(request)

    data_request = DataRequest.new
    data_request.host = host
    data_request.path = path
    data_request.query_str = as_str
    data_request.status_code = response.code.to_i
    data_request.when = Time.now
    data_request.save

    if response.code.to_i == 200
      [data_request, tratar_proposicoes(response.body), response]
    else
    # TODO tratar erro
      [data_request, [], response]
    end
  end

  def tratar_proposicoes(xml_body)
    proposicoes = []
    doc = Nokogiri::XML(xml_body)

    doc.xpath('//proposicao').each do |p|
      proposicao = Proposicao.new
      proposicao.tipo = p.xpath('./tipoProposicao/sigla').first.content.strip
      proposicao.numero = p.xpath('./numero').first.content.to_i
      proposicao.ano = p.xpath('./ano').first.content.to_i
      proposicao.autor_nome = p.xpath('./autor1[1]/txtNomeAutor').first.content.strip
      proposicao.autor_partido = p.xpath('./autor1[1]/txtSiglaPartido').first.content.strip
      proposicao.autor_uf = p.xpath('./autor1[1]/txtSiglaUF').first.content.strip
      proposicao.qtd_autores = p.xpath('./qtdAutores').first.content.to_i
      data_apresentacao = p.xpath('./datApresentacao').first.content.strip
      proposicao.ementa = p.xpath('./txtEmenta').first.content.strip
      proposicao.ementa_explicacao = p.xpath('./txtExplicacaoEmenta').first.content.strip

      # dd/mm/aaaa... to mm/dd/aaaa...
      proposicao.data_apresentacao = Date.parse data_apresentacao.sub(/^(\d+)\/(\d+)\/(.*)$/, '\2/\1/\3')

      proposicoes << proposicao
    end
    proposicoes
  end

  def buscar_votacoes(proposicao)

    if !proposicao.is_a? Proposicao
      raise 'Invalid parameters'
    end

    host = 'http://www.camara.gov.br'
    path = '/SitCamaraWS/Proposicoes.asmx/ObterVotacaoProposicao'
    url = host + path

    params_votacoes_proposicao = {
      :tipo => proposicao.tipo,
      :numero => proposicao.numero,
      :ano => proposicao.ano,
    }

    as_hash = params_votacoes_proposicao
    as_arr = []
    as_hash.each_pair do |k,v|
      as_arr << "#{k.to_s}=#{v.to_s}"
    end
    as_str = as_arr.join '&'

    request = Net::HTTP::Post.new(url)
    request.add_field 'Content-Type', 'application/x-www-form-urlencoded'
    request.add_field 'Accept', 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    # TODO parametrizar User-Agent
    request.add_field 'User-Agent', 'Politica.Me'
    request.body = as_str

    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.request(request)

    data_request = DataRequest.new
    data_request.host = host
    data_request.path = path
    data_request.query_str = as_str
    data_request.status_code = response.code.to_i
    data_request.when = Time.now
    data_request.save

    if response.code.to_i == 200
      [data_request, tratar_votacoes(response.body, proposicao), response]
    else
    # TODO tratar erro
      [data_request, [], response]
    end
  end

  def buscar_votacao(votacao)

    if !votacao.is_a? Votacao
      raise 'Invalid parameters'
    end

    proposicao = votacao.proposicao
    if proposicao.nil?
      raise "Proposicao não encontrada para votacao id=#{votacao.id}"
    end

    host = 'http://www.camara.gov.br'
    path = '/SitCamaraWS/Proposicoes.asmx/ObterVotacaoProposicao'
    url = host + path

    params_votacoes_proposicao = {
      :tipo => proposicao.tipo,
      :numero => proposicao.numero,
      :ano => proposicao.ano,
    }

    as_hash = params_votacoes_proposicao
    as_arr = []
    as_hash.each_pair do |k,v|
      as_arr << "#{k.to_s}=#{v.to_s}"
    end
    as_str = as_arr.join '&'

    request = Net::HTTP::Post.new(url)
    request.add_field 'Content-Type', 'application/x-www-form-urlencoded'
    request.add_field 'Accept', 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    # TODO parametrizar User-Agent
    request.add_field 'User-Agent', 'Politica.Me'
    request.body = as_str

    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.request(request)

    data_request = DataRequest.new
    data_request.host = host
    data_request.path = path
    data_request.query_str = as_str
    data_request.status_code = response.code.to_i
    data_request.when = Time.now
    data_request.save

    if response.code.to_i == 200
      [data_request, tratar_votacao(response.body, votacao), response]
    else
    # TODO tratar erro
      [data_request, [], response]
    end
  end

  def tratar_votacoes(xml_body, proposicao)
    votacoes = []
    doc = Nokogiri::XML(xml_body)

    doc.xpath('//Votacao').each do |v|
      votacao = Votacao.new
      votacao.proposicao = proposicao
      votacao.obj_votacao = v.xpath('./@ObjVotacao').first.content.strip
      votacao.resumo = v.xpath('./@Resumo').first.content.strip
      data_hora = v.xpath('./@Data').first.content.strip + ' ' + v.xpath('./@Hora').first.content.strip

      # dd/mm/aaaa... to mm/dd/aaaa...
      votacao.data_hora = DateTime.parse data_hora.sub(/^(\d+)\/(\d+)\/(.*)$/, '\2/\1/\3')

      votacoes << votacao
    end
    votacoes
  end

  def tratar_votacao(xml_body, votacao)
    doc = Nokogiri::XML(xml_body)

    v = doc.xpath("//Votacao[@Resumo='#{votacao.resumo}' and @ObjVotacao='#{votacao.obj_votacao}']")

    votos_deputados = []
    v.xpath('./votos/Deputado').each do |voto|
      voto_deputado = {}
      voto_deputado[:nome] = voto.xpath('./@Nome').first.content.strip
      voto_deputado[:partido] = voto.xpath('./@Partido').first.content.strip
      voto_deputado[:uf] = voto.xpath('./@UF').first.content.strip
      voto_dep = voto.xpath('./@Voto').first.content.strip

      voto_deputado[:voto] = case voto_dep
      when Voto::VOTE_YES_STR then Voto::VOTE_YES
      when Voto::VOTE_NO_STR then Voto::VOTE_NO
      when Voto::VOTE_ABSTENTION_STR then Voto::VOTE_ABSTENTION
      when Voto::VOTE_OBSTRUCTION_STR then Voto::VOTE_OBSTRUCTION
      else Voto::VOTE_OTHER
      end

      votos_deputados << voto_deputado
    end

    votacao.voto_deputados.create votos_deputados
    votacao
  end
end
