class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :set_cache
  def set_cache
    expires_now

    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def create
    begin
      super
    rescue Exception => ex
      if ex.is_a? ActiveRecord::RecordNotUnique
        flash[:error] = 'E-mail já cadastrado no sistema.'
      else
        flash[:error] = 'Desculpe, ocorreu um erro desconhecido ao tentar lhe registrar. Tente novamente mais tarde.'
      end
      redirect_to :action => 'new', :status => 303
    end
  end
end
