class Votacao < ActiveRecord::Base
  attr_accessible :data_hora, :id, :master, :obj_votacao, :resumo, :fetch_status

  validates_presence_of :proposicao
  validate :validate_unique_votacao

  belongs_to :proposicao
  has_many :voto_deputados, :autosave => true
  has_many :voto_users
  
  def validate_unique_votacao
    votacao_bd = Votacao.where(:proposicao_id => self.proposicao.id, :resumo => self.resumo).first
    if self.id.nil? and !votacao_bd.nil?
      errors.add :votacao, 'Votação deve ser única'
    elsif !self.id.nil? and !votacao_bd.nil? and self.id != votacao_bd.id
      errors.add :votacao, 'Votação deve ser única'
    end
  end
end
