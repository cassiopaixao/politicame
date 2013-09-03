class Voto < ActiveRecord::Base
  VOTES = [VOTE_YES = 2, VOTE_NO = -2, VOTE_ABSTENTION = -1, VOTE_OBSTRUCTION = 0, VOTE_OTHER = 0]
  VOTES_STR = [VOTE_YES_STR = 'Sim', VOTE_NO_STR = 'Não', VOTE_ABSTENTION_STR = 'Abstenção', VOTE_OBSTRUCTION_STR = 'Obstrução']

end