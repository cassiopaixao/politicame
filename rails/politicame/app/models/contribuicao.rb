class Contribuicao < ActiveRecord::Base
  attr_accessible :autor, :conteudo, :fonte, :id, :proposicao_id, :rotulo
  belongs_to :proposicao
end
