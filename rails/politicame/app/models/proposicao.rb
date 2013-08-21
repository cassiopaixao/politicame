class Proposicao < ActiveRecord::Base
  attr_accessible :ano, :autor_nome, :autor_partido, :autor_uf, :data_apresentacao, :ementa, :ementa_explicacao, :id, :numero, :qtd_autores, :tipo
  
  has_many :votacaos
end
