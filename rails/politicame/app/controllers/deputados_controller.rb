class DeputadosController < ApplicationController

	def show

		@deputados = Deputado.order("nome").page(params[:page]).per(20)

	end

end
