class ImportacaoDadosController < ApplicationController
  def index
    @data_requests = DataRequest.all
  end

  def proposicoes
    @proposicoes = Proposicao.all
  end

  def fetch_proposicoes
    begin
      initial_date = Date.parse params[:initial_date]
      end_date = Date.parse params[:end_date]
      type = params[:type]

      proposicoes = buscar_proposicoes initial_date, end_date, type
      
      proposicoes.each do |proposicao|
        proposicao.save!
      end

    rescue
      flash.now[:error] = 'Erro ao recuperar proposições.'
    end
  end

end
