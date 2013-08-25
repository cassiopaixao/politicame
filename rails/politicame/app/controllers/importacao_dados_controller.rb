class ImportacaoDadosController < ApplicationController
  include ImportacaoDadosHelper
  def index
    @data_requests = DataRequest.all
  end

  def proposicoes
    @proposicoes = Proposicao.all
  end

  def fetch_proposicoes
    begin
      initial_date = Date.parse params[:initial_date].strip.sub(/^(\d+)\/(\d+)\/(\d+)$/, '\2/\1/\3')
      end_date = Date.parse params[:end_date].strip.sub(/^(\d+)\/(\d+)\/(\d+)$/, '\2/\1/\3')
      fetch_votacoes = params[:fetch_votacoes] == '1'

      if initial_date.year != end_date.year
        raise 'Verifique se as datas são do mesmo ano'
      end

      @requisicoes = []
      @proposicoes = []
      @duplicadas = []
      @erros_gerais = []

      %(PL, PLC, PLN, PLP, PLS, PEC).each do |type|

        requisicao, proposicoes = buscar_proposicoes initial_date, end_date, type

        proposicoes.each do |proposicao|
          proposicao.fetch_status = Proposicao::NEVER_SEARCHED

          if proposicao.save
            busca_votacoes proposicao if fetch_votacoes

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

  private

  def busca_votacoes(proposicao)
    requisicao_votacao, votacoes, response = buscar_votacoes proposicao

    if response.code.to_i == 200 and !votacoes.empty?
      proposicao.fetch_status = Proposicao::FOUND

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
