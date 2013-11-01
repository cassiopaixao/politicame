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

class HomeController < ApplicationController
  def index
    proposicoes_ids = Votacao.where(:master => 1).pluck(:proposicao_id)
    @proposicoes = Proposicao.find(proposicoes_ids, :limit => 3)
  end

  def idea
  end

  def about
  end
  
  def nota
  end

  def next_steps
  end

  def subscribe
    s = Subscription.new
    s.name = params[:name]
    s.email = params[:email]
    s.subscribed_at = Time.now

    if s.save
      flash.now[:success] = 'Obrigado por se registrar. Lhe manteremos atualizado(a) com as novidades do projeto!'
    else
      if !s.valid?
        flash.now[:error] = 'Houve problema no preenchimento dos campos. Favor verificá-los e tentar novamente. Obrigado.'
      else
        flash.now[:error] = 'Desculpe o incoveniente. Ocorreu uma falha ao registrar seu e-mail. Tente novamente mais tarde.'
      end
      @subscription = s
    end
    render 'idea'
  end
end
