class Proposicao < ActiveRecord::Base
  FETCH_STATUSES = [NEVER_SEARCHED = 0, NOT_FOUND = 1, FOUND = 2, UNKNOWN_ERROR = 3]
  
  attr_accessible :ano, :autor_nome, :autor_partido, :autor_uf, :data_apresentacao, :ementa, :ementa_explicacao, :id, :numero, :qtd_autores, :tipo, :fetch_status

  validates_presence_of :tipo
  validates_presence_of :numero
  validates_presence_of :ano
  validate :validate_unique_proposicao

  has_many :votacaos
  
  def validate_unique_proposicao
    if !Proposicao.where(:tipo => self.tipo, :numero => self.numero, :ano => self.ano).empty?
      errors.add :proposicao, 'Proposição deve ser única'
    end
  end
end
