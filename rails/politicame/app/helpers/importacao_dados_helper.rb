module ImportacaoDadosHelper
  require 'net/http'
  require 'uri'
  require 'nokogiri'

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
      :sigla => type
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
    request.add_field 'User-Agent', 'Um site qualquer'
    request.body = as_str

    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.request(request)

    data_request = DataRequest.new
    data_request.host = host
    data_request.path = path
    data_request.query_str = as_str
    data_request.status_code = response.code
    data_request.when = Time.now
    data_request.save
    
    if response.code == 200
      tratar_proposicoes response.body
    else
      # TODO tratar erro
      nil
    end
  end
  
  def tratar_proposicoes(xml_body)
    proposicoes = []
    doc = Nokogiri::XML(response.body)
    doc.xpath('//proposicao').each do |p|
      proposicao = Proposicao.new
      proposicao.tipo = p.xpath('./tipoProposicao/sigla').first.content.strip
      proposicao.numero = p.xpath('./numero').first.content.to_i
      proposicao.ano = p.xpath('./ano').first.content.to_i
      proposicao.autor_nome = p.xpath('./autor1[1]/txtNomeAutor').first.content.strip
      proposicao.autor_partido = p.xpath('./autor1[1]/txtSiglaPartido').first.content.strip
      proposicao.autor_uf = p.xpath('./autor1[1]/txtSiglaUF').first.content.strip
      proposicao.qtd_autores = p.xpath('./qtdAutores').first.content.to_i
      proposicao.data_apresentacao = p.xpath('./datApresentacao').first.content.strip
      proposicao.ementa = p.xpath('./txtEmenta').first.content.strip
      proposicao.ementa_explicacao = p.xpath('./txtExplicacaoEmenta').first.content.strip

      # dd/mm/aaaa... to mm/dd/aaaa...      
      proposicao.data_apresentacao = Date.parse proposicao.data_apresentacao.sub(/^(\d+)\/(\d+)\/(.*)$/, '\2/\1/\3')
      
      proposicoes << proposicao
    end
    proposicoes
  end
end
