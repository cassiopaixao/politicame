class VotoDeputado < ActiveRecord::Base
  attr_accessible :id, :nome, :partido, :uf, :voto
  
  validates_presence_of :votacao
  validates_presence_of :voto
  
  belongs_to :votacao
end
