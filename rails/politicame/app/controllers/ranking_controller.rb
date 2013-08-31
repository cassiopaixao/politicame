class RankingController < ApplicationController
  before_filter :verify_user_login
  def show
    @votos_usuario = VotoUser.includes(:votacao => [:voto_deputados, :proposicao]).where(:user_id => current_user.id)

    ranking_hash = calcula_ranking(@votos_usuario)
    @ranking = ranking_hash.to_a.sort! {|x,y| y[1] <=> x[1]}
  end

  private

  def verify_user_login
    if !user_signed_in?
      flash[:alert] = 'É necessário entrar no sistema para visualizar essa página.'
      redirect_to new_user_session_path, :status => 303
    end
  end

  def calcula_ranking(votos_usuario)
    ranking = Hash.new 0

    votos_usuario.each do |voto_usuario|
      voto_usuario.votacao.voto_deputados.each do |voto_deputado|
        variacao = 0
        if voto_usuario.voto == voto_deputado.voto
          variacao = 1
        elsif voto_usuario.voto + voto_deputado.voto == 3 # votos contrários
          variacao = -1
        end
        ranking[voto_deputado.nome] = ranking[voto_deputado.nome] + variacao
      end
    end
    
    ranking
  end
end