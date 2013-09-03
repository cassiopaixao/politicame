class RankingController < ApplicationController
  before_filter :verify_user_login
  
  def show
    ranking_hash = calcula_ranking current_user.id
    @ranking = ranking_hash.to_a.sort {|x,y| y[:rank] <=> x[:rank]}
    @max_rank = @ranking.first.nil? ? 1 : @ranking.first[:rank]
    @min_rank = (@ranking.last.nil? or @ranking.last[:rank] > 0) ? 0 : @ranking.last[:rank]
    @range = (@max_rank.to_i - @min_rank.to_i)
  end

  private

  def verify_user_login
    if !user_signed_in?
      flash[:alert] = 'É necessário entrar no sistema para visualizar essa página.'
      redirect_to new_user_session_path, :status => 303
    end
  end

  def calcula_ranking(user_id)
    conn = ActiveRecord::Base.connection
    query = 'SELECT vd.nome, vd.partido, vd.uf, SUM(vu.voto * vd.voto) AS rank
     FROM voto_users vu INNER JOIN voto_deputados vd ON vu.votacao_id = vd.votacao_id
     WHERE vu.user_id = %d
     GROUP BY vd.nome, vd.partido, vd.uf
     ORDER BY rank DESC' % user_id
    result = conn.select_all query

    result = result.to_a
    result.each do |rank|
      rank.symbolize_keys!
    end
    result
  end
end