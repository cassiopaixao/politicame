class Proposicao < ActiveRecord::Base
  FETCH_STATUSES = [NEVER_SEARCHED = 0, NOT_FOUND = 1, FOUND = 2, UNKNOWN_ERROR = 3]

  paginates_per 9

  attr_accessible :ano, :autor_nome, :autor_partido, :autor_uf, :data_apresentacao, :ementa, :ementa_explicacao, :id, :numero, :qtd_autores, :tipo, :fetch_status

  validates_presence_of :tipo
  validates_presence_of :numero
  validates_presence_of :ano
  validate :validate_unique_proposicao

  has_many :votacaos, :autosave => true
  has_many :proposicao_relevancia

  def validate_unique_proposicao
    proposicao_bd = Proposicao.where(:tipo => self.tipo, :numero => self.numero, :ano => self.ano).first
    if self.id.nil? and !proposicao_bd.nil?
      errors.add :proposicao, 'Proposição deve ser única'
    elsif !self.id.nil? and !proposicao_bd.nil? and self.id != proposicao_bd.id
      errors.add :proposicao, 'Proposição deve ser única'
    end
  end

  def to_s
    "#{tipo.upcase} #{numero}/#{ano}"
  end

  def votacao
    self.votacaos.select{|v| v.master}.first
  end
end
