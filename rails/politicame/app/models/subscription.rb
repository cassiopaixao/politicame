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

class Subscription < ActiveRecord::Base
  attr_accessible :id, :email, :name, :subscribed_at, :unsubscribed_at
  
  validate :validate_email
  
  # this just work because there aren't updates, just new subscriptions
  def validate_email
    self.email = self.email.downcase.rstrip if !self.email.nil?
    errors.add :email, 'E-mail deve ser preenchido' if self.email.nil? or self.email.empty?
    errors.add :email, 'E-mail já cadastrado' if !Subscription.find_by_email(self.email).nil?
    errors.add :email, 'E-mail invalido' if /^([^@\s]+)@(([-a-z0-9]+\.)+[a-z]{2,})$/.match(self.email).nil?
  end
end
