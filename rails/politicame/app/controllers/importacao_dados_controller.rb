class ImportacaoDadosController < ApplicationController
  include ImportacaoDadosHelper
  def index
    @data_requests = DataRequest.order('id DESC').page params[:page]
  end

  def proposicoes
    @proposicoes = Proposicao.order('id DESC').page params[:page]
  end

  def votacoes
    proposicoes_ids = Votacao.group(:proposicao_id).having('sum(master) = 0').pluck(:proposicao_id)
    @proposicoes = Proposicao.includes(:votacaos).find(proposicoes_ids)
  end

  def fetch_proposicoes
    begin
      initial_date = Date.strptime params[:initial_date], '%d/%m/%Y'
      end_date = Date.strptime params[:end_date], '%d/%m/%Y'
      fetch_votacoes_var = params[:fetch_votacoes] == '1'

      if initial_date.year != end_date.year
        raise 'Verifique se as datas são do mesmo ano'
      end

      @requisicoes = []
      @proposicoes = []
      @duplicadas = []
      @erros_gerais = []

      %w(PL PLC PLN PLP PLS PEC MPV).each do |type|
        requisicao, proposicoes = buscar_proposicoes initial_date, end_date, type

        proposicoes.each do |proposicao|
          proposicao.fetch_status = Proposicao::NEVER_SEARCHED

          if proposicao.save
            busca_votacoes proposicao

          else
            if proposicao.errors.messages[:proposicao] == 'Proposição deve ser única'
            @duplicadas << proposicao
            else
            @erros_gerais << proposicao
            end
          end
          @proposicoes << proposicao
        end
      end

      if @duplicadas.empty? and @erros_gerais.empty?
        flash.now[:success] = 'Requisição processada com sucesso!'
      else
        flash.now[:alert] = 'Requisição processada com sucesso. Confira abaixo os erros que ocorreram.'
      end

    rescue Exception => ex
      flash.now[:error] = 'Erro ao recuperar proposições. Entre em contato com o administrador do sistema.'
      puts "ERROR: #{ex.message}"
      puts ex.backtrace.join('\n')
    end
  end

  def set_masters
    propostas_ids = []
    params.each_pair do |k,v|
      propostas_ids << /^proposta_(\d+)$/.match(k.to_s)[1] if !/^proposta_(\d+)$/.match(k.to_s).nil?
    end

    @proposicoes = Proposicao.includes(:votacaos).find(propostas_ids)

    @proposicoes.each do |proposta|
      new_master = params["proposta_#{proposta.id}"].to_i
      if new_master == 0
        next
      end
      proposta.votacaos.each do |votacao|
        votacao.master = votacao.id == new_master
      end
    end

    @proposicoes.each do |proposta|
      votacao = proposta.votacao

      if votacao.nil?
        next
      end

      if votacao.fetch_status != Proposicao::FOUND

        requisicao, votacao_processada, response = buscar_votacao votacao

        if response.code.to_i == 200 and !votacao.voto_deputados.empty?
          votacao.fetch_status = Proposicao::FOUND
        elsif response.code.to_i == 200
          votacao.fetch_status = Proposicao::NOT_FOUND
        else
          votacao.fetch_status = Proposicao::UNKNOWN_ERROR
        end
      votacao.save
      end
    end

  end

  def fetch_votacoes
    begin

      @tipo = params[:tipo].strip
      @numero = params[:numero].strip
      @ano = params[:ano].strip

      @requisicoes = []
      @votacoes = []
      @duplicadas = []
      @erros_gerais = []

      @proposicao = Proposicao.where(:tipo => @tipo, :numero => @numero, :ano => @ano).first

      if @proposicao.nil?
        raise 'Proposicão não existente'
      end

      @requisicao, votacoes = buscar_votacoes @proposicao

      votacoes.each do |votacao|
        if !votacao.save
          if votacao.errors[:votacao] == 'Votação deve ser única'
          @duplicadas << votacao
          else
          @erros_gerais << votacao
          end
        end
        @votacoes << votacao
      end

      if @duplicadas.empty? and @erros_gerais.empty?
        flash.now[:success] = 'Requisição processada com sucesso!'
        @proposicao.fetch_status = Proposicao::FOUND
      else
        flash.now[:alert] = 'Requisição processada com sucesso. Confira abaixo os erros que ocorreram.'
        @proposicao.fetch_status = Proposicao::UNKNOWN_ERROR
      end
    rescue Exception => ex
      flash.now[:error] = 'Erro ao recuperar votações. Entre em contato com o administrador do sistema.'
      puts "ERROR: #{ex.message}"
      puts ex.backtrace.join('\n')

      @proposicao.fetch_status = Proposicao::UNKNOWN_ERROR
    ensure
    @proposicao.save
    end
  end

  def fetch_votacoes_get
    begin

      @tipo = params[:tipo].strip
      @numero = params[:numero].strip
      @ano = params[:ano].strip

      @requisicoes = []
      @votacoes = []
      @duplicadas = []
      @erros_gerais = []

      @proposicao = Proposicao.where(:tipo => @tipo, :numero => @numero, :ano => @ano).first

      if @proposicao.nil?
        raise 'Proposicão não existente'
      end

      @requisicao, votacoes = buscar_votacoes @proposicao

      votacoes.each do |votacao|
        if !votacao.save
          if votacao.errors[:votacao] == 'Votação deve ser única'
          @duplicadas << votacao
          else
          @erros_gerais << votacao
          end
        end
        @votacoes << votacao
      end

      if @duplicadas.empty? and @erros_gerais.empty?
        flash.now[:success] = 'Requisição processada com sucesso!'
        @proposicao.fetch_status = Proposicao::FOUND
      else
        flash.now[:alert] = 'Requisição processada com sucesso. Confira abaixo os erros que ocorreram.'
        @proposicao.fetch_status = Proposicao::UNKNOWN_ERROR
      end
    rescue Exception => ex
      flash.now[:error] = 'Erro ao recuperar votações. Entre em contato com o administrador do sistema.'
      puts "ERROR: #{ex.message}"
      puts ex.backtrace.join('\n')

      @proposicao.fetch_status = Proposicao::UNKNOWN_ERROR
    ensure
    @proposicao.save
    end
  end

  def importar_deputados()

    @deputados_view = importar_deputados_ws

  end

  # TODO corrigir a lógica de atualização. Desevolvido durante hackathon para
  # buscar id dos deputados.
  def cadastrar_deputados()

    deputados = importar_deputados_ws

    deputados.each { |deputado|
      deputado_obj = Deputado.where(:nome => deputado.nome,
                                    :partido => deputado.partido,
                                    :uf => deputado.uf
                                    ).first
      if deputado_obj.nil?
        deputado.save
      else
        deputado_obj.id_camara = deputado.id_camara
        deputado_obj.matricula = deputado.matricula
        deputado_obj.save
      end
    }

    @deputados_view = deputados

    flash[:success] = "Deputados atualizados com sucesso!"

    render :importar_deputados

  end


  private

  def importar_deputados_ws()

    requisicao, deputados, response = importar_deputados_helper

    if response.code.to_i == 200
      deputados
    else
      []
    end

  end

  def busca_votacoes(proposicao)
    requisicao_votacao, votacoes, response = buscar_votacoes proposicao

    if response.code.to_i == 200 and !votacoes.empty?
      proposicao.fetch_status = Proposicao::FOUND
      votacoes.each do |v|
        v.save
      end

    elsif response.code.to_i == 200 and votacoes.empty?
      proposicao.fetch_status = Proposicao::NOT_FOUND
    else
      proposicao.fetch_status = Proposicao::UNKNOWN_ERROR
    end

    if !proposicao.save
      puts 'ERROR: ' + proposicao.errors.inspect
    end
  end

end
