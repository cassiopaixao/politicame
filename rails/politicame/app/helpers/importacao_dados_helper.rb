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

    __chama_webservice(host, path, as_hash, "tratar_proposicoes", [])

  end

  def tratar_proposicoes(xml_body, args)
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

      proposicao.data_apresentacao = Date.strptime data_apresentacao, '%d/%m/%Y'

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

    params_votacoes_proposicao = {
      :tipo => proposicao.tipo,
      :numero => proposicao.numero,
      :ano => proposicao.ano,
    }

    __chama_webservice(host, path, params_votacoes_proposicao,
      "tratar_votacoes", proposicao)

  end

  def __chama_webservice(host, path, params, callback, callback_params)

    url = host + path

    #params_votacoes_proposicao = {
    #  :tipo => proposicao.tipo,
    #  :numero => proposicao.numero,
    #  :ano => proposicao.ano,
    #}

    as_hash = params
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
      [data_request, self.send(callback, response.body, callback_params), response]
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

    params_votacoes_proposicao = {
      :tipo => proposicao.tipo,
      :numero => proposicao.numero,
      :ano => proposicao.ano,
    }

    __chama_webservice(host, path, params_votacoes_proposicao,
      "tratar_votacao", [votacao])

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

      # http://ruby-doc.org/stdlib-2.0.0/libdoc/date/rdoc/DateTime.html#method-i-strftime
      votacao.data_hora = DateTime.strptime data_hora, "%d/%m/%Y %H:%M"

      votacoes << votacao
    end
    votacoes
  end

  def tratar_votacao(xml_body, args)
    doc = Nokogiri::XML(xml_body)

    votacao = args[0]

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

  def importar_deputados_helper()

    host = 'http://www.camara.gov.br'
    path = '/SitCamaraWS/Deputados.asmx/ObterDeputados'

    params_deputados = {

    }

    __chama_webservice(host, path, params_deputados,
      "tratar_deputados", [])

  end

  def tratar_deputados(xml_body, args)

    doc = Nokogiri::XML(xml_body)

    deputados = []

    doc.xpath('//deputado').each do |deputado|

      deputadoObj = Deputado.new
      deputadoObj.nome      = deputado.xpath('./nomeParlamentar').first.content.strip
      deputadoObj.uf        = deputado.xpath('./uf').first.content.strip
      deputadoObj.partido   = deputado.xpath('./partido').first.content.strip
      deputadoObj.email     = deputado.xpath('./email').first.content.strip
      deputadoObj.telefone  = deputado.xpath('./fone').first.content.strip
      deputadoObj.condicao  = deputado.xpath('./condicao').first.content.strip
      deputadoObj.id_camara = deputado.xpath('./ideCadastro').first.content.strip.to_i

      deputados << deputadoObj

    end

    deputados
  end

end
