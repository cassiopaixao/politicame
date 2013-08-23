class Votacao < ActiveRecord::Base
  attr_accessible :data_hora, :id, :master, :obj_votacao, :resumo
  
  validates_presence_of :proposicao  
  validate :validate_unique_votacao

  belongs_to :proposicao
  has_many :voto_deputados, :autosave => true
  
  def validate_unique_votacao
    if !Votacao.where(:proposicao => self.proposicao, :resumo => self.resumo).empty?
      errors.add :votacao, 'Votaçaõ deve ser única'
    end
  end
end
