class Voto < ActiveRecord::Base
  VOTES = [VOTE_YES = 1, VOTE_NO = 2, VOTE_ABSTENTION = 3, VOTE_OBSTRUCTION = 4, VOTE_OTHER = 0]
  VOTES_STR = [VOTE_YES_STR = 'Sim', VOTE_NO_STR = 'Não', VOTE_ABSTENTION_STR = 'Abstenção', VOTE_OBSTRUCTION_STR = 'Obstrução']

end