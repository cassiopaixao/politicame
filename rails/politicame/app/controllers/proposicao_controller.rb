class ProposicaoController < ApplicationController
  before_filter :get_proposicao, :only => [:show, :register_vote]
  
  def index
    proposicoes_ids = Votacao.where(:master => 1).pluck(:proposicao_id)
    @proposicoes = Proposicao.find(proposicoes_ids).page params[:page]
  end

  def show
  end

  def register_vote
    #TODO
    #pega usuario
    #busca voto
    #altera ou cria
    #salva
    if !user_signed_in?
      flash[:error] = 'Você precisa fazer login, ou se registrar, para poder votar.'
    else
      voto = VotoUser.where(:user_id => current_user.id, :votacao_id => @votacao.id).first

      if voto.nil?
        voto = VotoUser.new
        voto.user = current_user
      voto.votacao = @votacao
      end

      voto.voto = case params[:vote]
      when Voto::VOTE_YES_STR then Voto::VOTE_YES
      when Voto::VOTE_NO_STR then Voto::VOTE_NO
      when Voto::VOTE_ABSTENTION_STR then Voto::VOTE_ABSTENTION
      when Voto::VOTE_OBSTRUCTION_STR then Voto::VOTE_OBSTRUCTION
      else Voto::VOTE_OTHER
      end

      if voto.save
        flash[:success] = "Voto registrado com sucesso."
      else
        flash[:error] = "Erro ao processar sua opinião sobre #{@proposicao.to_s}. Isso não deveria acontecer :/ . Pedimos que informe-nos sobre esse problema pelo e-mail #{mail_to 'cassio.paixao@gmail.com'}"
      end
    end
    redirect_to :action => 'show', :tipo => @proposicao.tipo, :numero => @proposicao.numero, :ano => @proposicao.ano
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

    @votacao = Votacao.where(:proposicao_id => @proposicao.id, :master => '1').first

    if @votacao.nil?
      flash[:error] = "#{@proposicao.to_s} existe, mas não há votação registrada para a mesma."
      redirect_to :action => 'index'
    end
  end
end
