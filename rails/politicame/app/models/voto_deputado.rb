class VotoDeputado < ActiveRecord::Base
  VOTES = [VOTE_YES = 1, VOTE_NO = 2, VOTE_ABSTENTION = 3, VOTE_OBSTRUCTION = 4, VOTE_OTHER = 0]
  VOTES_STR = [VOTE_YES_STR = 'Sim', VOTE_NO_STR = 'No', VOTE_ABSTENTION_STR = 'Abstenção', VOTE_OBSTRUCTION_STR = 'Obstrução']
  
  attr_accessible :id, :nome, :partido, :uf, :voto
  
  validates_presence_of :votacao
  validates_presence_of :voto
  
  belongs_to :votacao
end
