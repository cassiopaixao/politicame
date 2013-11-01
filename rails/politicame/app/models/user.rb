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

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  # :recoverable, :validatable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  has_many :voto_users
  has_many :proposica_relevancia

  validates_presence_of :email, :message => 'Um e-mail deve ser informado'
  validates_uniqueness_of :email, :message => 'E-mail já cadastrado no sistema'
  validates_presence_of :password, :on => :create, :message => 'Uma senha deve ser informada'
  validates_confirmation_of :password, :message => 'A senha repetida não coincide com a informada'

end
