class VotoDeputado < ActiveRecord::Base
  attr_accessible :id, :nome, :partido, :uf, :voto
  
  belongs_to :votacao
end
