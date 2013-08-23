class Proposicao < ActiveRecord::Base
  attr_accessible :ano, :autor_nome, :autor_partido, :autor_uf, :data_apresentacao, :ementa, :ementa_explicacao, :id, :numero, :qtd_autores, :tipo

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
