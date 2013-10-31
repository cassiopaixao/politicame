class PresencaSessao < ActiveRecord::Base
  attr_accessible :ausencia, :deputado_id, :fim, :inicio, :presenca
end
