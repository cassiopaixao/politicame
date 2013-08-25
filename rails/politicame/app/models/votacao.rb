class Votacao < ActiveRecord::Base
  attr_accessible :data_hora, :id, :master, :obj_votacao, :resumo
  
  validates_presence_of :proposicao  
  validate :validate_unique_votacao

  belongs_to :proposicao
  has_many :voto_deputados, :autosave => true
  
  def validate_unique_votacao
    if !Votacao.where(:proposicao_id => self.proposicao.id, :resumo => self.resumo).empty?
      errors.add :votacao, 'Votação deve ser única'
    end
  end
end
