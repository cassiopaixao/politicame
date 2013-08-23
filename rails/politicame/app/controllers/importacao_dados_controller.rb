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
          if !proposicao.save
            if proposicao.errors[:proposicao] == 'Proposição deve ser única'
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

end
