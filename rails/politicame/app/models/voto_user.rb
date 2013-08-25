class VotoUser < ActiveRecord::Base
  attr_accessible :user_id, :votacao_id, :voto

  validates_presence_of :votacao
  validates_presence_of :user
  validates_presence_of :voto

  belongs_to :votacao
  belongs_to :user
end
