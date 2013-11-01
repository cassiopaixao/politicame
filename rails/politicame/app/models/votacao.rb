# Copyright 2013 de PoliticaMe/Cassio Paixao e Max Rosan.
# Este arquivo e parte do programa PoliticaMe. 
# O PoliticaMe e um software livre; voce pode redistribui-lo e/ou modifica-lo 
# dentro dos termos da GNU General Public License.
# como publicada pela Fundacao do Software Livre (FSF); na versao 3 da Licenca. 
# Este programa e distribuido na esperanca que possa ser util, 
# mas SEM NENHUMA GARANTIA; sem uma garantia implicita de ADEQUACAO a qualquer MERCADO ou APLICACAO EM PARTICULAR.
# Veja a licenca para maiores detalhes. 
# Voce deve ter recebido uma copia da GNU General Public License, 
# sob o titulo "LICENCA.txt", junto com este programa, se nao, acesse http://www.gnu.org/licenses/

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
