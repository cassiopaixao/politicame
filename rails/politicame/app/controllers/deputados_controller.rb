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

class DeputadosController < ApplicationController

	def index

		@twitter = Hash.new

		if params[:uf].nil? || params[:uf].empty?
			@deputados = Deputado.order("nome").page(params[:page]).per(20)
		else
			@deputados = Deputado.where(:uf => params[:uf]).order("nome").page(params[:page]).per(20)
		end

		@deputados.each do |d|
			@twitter[d.id] = Twitter.where(:deputado_id => d.id).first
		end

		@estados   = Deputado.group("uf").order("uf").collect{ |d| d.uf }
		@selected_estado = params[:uf]

	end

	def show

		@deputado   = Deputado.where(:id => params[:id]).first
		@votos_dep  = VotoDeputado.where(:nome => @deputado.nome, :uf => @deputado.uf, :partido => @deputado.partido)

		@count_pls  = @votos_dep.count
		@count_afavor  = @votos_dep.where(:voto => 2).count
		@count_contra  = @votos_dep.where(:voto => -2).count
		@count_abstencao  = @votos_dep.where(:voto => -1).count
		@count_obstrucao = @votos_dep.where(:voto => 0).count
		@total = @votos_dep.sum("voto")

		@presenca = PresencaSessao.where(:deputado_id => @deputado.id).first


		@hash_votos_user = Hash.new

		if user_signed_in? then
			@votos_dep.each do |vd|
			 voto_user = VotoUser.where(:user_id => current_user.id, :votacao_id => vd.votacao_id).first
			 if !voto_user.nil? then
			 	@hash_votos_user[vd.id] = voto_user.voto
			 end
			end
		end

		@twitter = Twitter.where(:deputado_id => @deputado.id).first

		if !@twitter.nil? then
			@twitter_username = @twitter.address.split("/")[-1]
		end

	end

end
