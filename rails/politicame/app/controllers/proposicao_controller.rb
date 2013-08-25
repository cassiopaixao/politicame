class ProposicaoController < ApplicationController
  before_filter :get_proposicao, :only => [:show, :register_vote]

  def index
    @proposicoes = Proposicao.all
  end

  def show
  end

  def register_vote
    #TODO
    #pega usuario
    #busca voto
    #altera ou cria
    #salva
    if user_signed_in?
      novo_voto = params[:vote]
      
    end
  end

  private

  def get_proposicao
    tipo = params[:tipo].strip[0..2].upcase
    numero = params[:numero].to_i
    ano = params[:ano].to_i

    @proposicao = Proposicao.where(:tipo => tipo, :numero => numero, :ano => ano).first

    if @proposicao.nil?
      flash[:error] = "Proposta #{tipo} #{numero}/#{ano} não existe."
      redirect_to :action => 'index'
    end
  end
end
