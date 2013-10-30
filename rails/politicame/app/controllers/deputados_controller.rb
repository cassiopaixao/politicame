class DeputadosController < ApplicationController

	def show

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

	def ver_pls

		@deputado   = Deputado.where(:id => params[:id]).first
		@votos_dep  = VotoDeputado.where(:nome => @deputado.nome, :uf => @deputado.uf, :partido => @deputado.partido)

		@count_pls  = @votos_dep.count
		@count_afavor  = @votos_dep.where(:voto => 2).count
		@count_contra  = @votos_dep.where(:voto => -2).count
		@count_abstencao  = @votos_dep.where(:voto => -1).count
		@count_obstrucao = @votos_dep.where(:voto => 0).count
		@total = @votos_dep.sum("voto")

		@twitter = Twitter.where(:deputado_id => @deputado.id).first

		if !@twitter.nil? then
			@twitter_username = @twitter.address.split("/")[-1]
		end

	end

end
