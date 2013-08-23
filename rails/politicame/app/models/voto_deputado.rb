class VotoDeputado < ActiveRecord::Base
  attr_accessible :id, :nome, :partido, :uf, :voto
  
  validates_presence_of :votacao
  
  belongs_to :votacao
end
