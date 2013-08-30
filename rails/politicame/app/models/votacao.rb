class Votacao < ActiveRecord::Base
  attr_accessible :data_hora, :id, :master, :obj_votacao, :resumo, :fetch_status

  validates_presence_of :proposicao
  validate :validate_unique_votacao

  belongs_to :proposicao
  has_many :voto_deputados, :autosave => true
  has_many :voto_users
 
  def validate_unique_votacao
    votacao_bd = Votacao.where(:proposicao_id => proposicao.id, :resumo => resumo).first
    if (id.nil? and !votacao_bd.nil?) or (!id.nil? and !votacao_bd.nil? and id != votacao_bd.id)
      errors.add :votacao, 'Votação deve ser única'
    end
  end
end
