class DeputadosController < ApplicationController

	def show

		if params[:uf].nil?
			@deputados = Deputado.order("nome").page(params[:page]).per(20)
		else
			@deputados = Deputado.where(:uf => params[:uf]).order("nome").page(params[:page]).per(20)
		end

		@estados   = Deputado.group("uf").order("uf").collect{ |d| d.uf }
		@selected_estado = ''

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

	end

end
