# Copyright 2013 de PoliticaMe/Cassio Paixao e Max Rosan.
# Este arquivo e parte do programa PoliticaMe.
# O PoliticaMe e um software livre; voce pode redistribui-lo e/ou modifica-lo
# dentro dos termos da GNU General Public License.
# como publicada pela Fundacao do Software Livre (FSF); na versao 3 da Licenca.
# Este programa e distribuido na esperanca que possa ser util,
# mas SEM NENHUMA GARANTIA; sem uma garantia implicita de ADEQUACAO a qualquer MERCADO ou APLICACAO EM PARTICULAR.
# Veja a licenca para maiores detalhes.
# Voce deve ter recebido uma copia da GNU General Public License,
# sob o titulo "LICENCA.txt", junto com este programa, se nao, acesse http://www.gnu.org/licenses/

class RankingController < ApplicationController
  before_filter :verify_user_login

  def show
    ranking = calcula_ranking2 current_user.id
    @ranking = ranking.sort {|x,y| y[:rank] <=> x[:rank]}
    @max_rank = @ranking.first.nil? ? 1 : @ranking.first[:rank]
    @min_rank = (@ranking.last.nil? or @ranking.last[:rank] > 0) ? 0 : @ranking.last[:rank]
    @range = (@max_rank.to_i - @min_rank.to_i)

    fill_estados_and_partidos @ranking

    @selected_estado = ''
    @selected_partido = ''
  end

  def show_filtered
    self.show

    @selected_estado = params[:uf]
    @selected_partido = params[:partido]

    fill_estados_and_partidos @ranking

    if @selected_estado.present?
      @ranking = @ranking.select {|r| r[:deputado].uf == @selected_estado}
    end
    if @selected_partido.present?
      @ranking = @ranking.select {|r| r[:deputado].partido == @selected_partido}
    end

    render :show
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

  def calcula_ranking2(user_id)
    votos_user = VotoUser.where('user_id', user_id)
    votacoes_ids = votos_user.pluck(:votacao_id)
    deputados = Deputado.includes(:voto_deputados).where('voto_deputados.votacao_id', votacoes_ids)

    ranking_list = []
    deputados.each do |dep|
      rank_value = 0
      ambos_votaram = 0
      dep.voto_deputados.each do |voto_dep|
        voto_user = votos_user.find { |voto| voto.votacao_id == voto_dep.votacao_id }
        if voto_user.present?
          rank_value += voto_user.voto * voto_dep.voto
          ambos_votaram += 1
        end
      end
      if ambos_votaram > 0
        rank_value = rank_value.to_f / ambos_votaram
        ranking_list << { deputado: dep,
                          rank: rank_value
                          }
      end
    end
    ranking_list
  end

  def fill_estados_and_partidos(ranking)
    @estados = []
    @partidos = []
    @ranking.each do |r|
      @estados << r[:deputado].uf
      @partidos << r[:deputado].partido
    end
    @estados = @estados.uniq.sort
    @partidos = @partidos.uniq.sort
  end
end