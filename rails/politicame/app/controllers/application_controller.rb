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

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_cache

  def set_cache
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end
