class HomeController < ApplicationController
  def index
  end

  def contribute
  end

  def subscribe
    s = Subscription.new
    s.name = params[:name]
    s.email = params[:email]
    s.subscribed_at = Time.now

    if s.save
      flash.now[:success] = 'Obrigado por se registrar. Lhe manteremos atualizad@ com as novidades do projeto!'
    else
      if !s.valid?
        flash.now[:error] = 'Houve problema no preenchimento dos campos. Favor verificá-los e tentar novamente. Obrigado.'
      else
        flash.now[:error] = 'Desculpe o incoveniente. Ocorreu uma falha ao registrar seu e-mail. Tente novamente mais tarde.'
      end
      @subscription = s
    end
    render 'index'
  end
end
