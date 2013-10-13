class Deputado < ActiveRecord::Base
  attr_accessible :condicao, :email, :id, :nome, :partido, :telefone, :uf
end
