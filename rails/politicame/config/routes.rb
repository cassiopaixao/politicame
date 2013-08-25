Politicame::Application.routes.draw do
  devise_for :users, :path => 'usuario',
    :controllers => {
      :sessions => 'users/sessions',
      :registrations => 'users/registrations' },
    :path_names => {
      :sign_in => 'entrar',
      :sign_out => 'sair',
      :password => 'senha',
      :confirmation => 'verificacao',
      :unlock => 'desbloquear',
      :registration => 'cadastro',
      :sign_up => 'registrar' }
  
  # scope :users, :path => 'usuario' do
    # root :to => 'users/profile#index'
  # end

  root :to => 'home#index'

  match 'sobre' => 'home#about', :via => [:get]
  match 'proximos_passos' => 'home#next_steps', :via => [:get]
  match 'assine' => 'home#subscribe', :via => [:post]
  get 'assine', :to => redirect('/')

  match 'importacao' => 'importacao_dados#index', :via => [:get]
  match 'importacao/proposicoes' => 'importacao_dados#proposicoes', :via => [:get]
  match 'importacao/proposicoes' => 'importacao_dados#fetch_proposicoes', :via => [:post]
  match 'importacao/votacoes' => 'importacao_dados#fetch_votacoes', :via => [:post]
  match 'importacao/votacoes/:tipo-:numero-:ano' => 'importacao_dados#fetch_votacoes_get', :via => [:get]

  match 'propostas/:tipo-:numero-:ano' => 'proposicao#show', :via => [:get], :constraints => {:tipo => /[A-Za-z]{2,3}/, :numero => /\d+/, :ano => /\d{4}/}
  match 'propostas/:tipo-:numero-:ano-:vote' => 'proposicao#register_vote', :via => [:get], :constraints => {:tipo => /[A-Za-z]{2,3}/, :numero => /\d+/, :ano => /\d{4}/}
  match 'propostas' => 'proposicao#index', :via => [:get]

# The priority is based upon order of creation:
# first created -> highest priority.

# Sample of regular route:
#   match 'products/:id' => 'catalog#view'
# Keep in mind you can assign values other than :controller and :action

# Sample of named route:
#   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
# This route can be invoked with purchase_url(:id => product.id)

# Sample resource route (maps HTTP verbs to controller actions automatically):
#   resources :products

# Sample resource route with options:
#   resources :products do
#     member do
#       get 'short'
#       post 'toggle'
#     end
#
#     collection do
#       get 'sold'
#     end
#   end

# Sample resource route with sub-resources:
#   resources :products do
#     resources :comments, :sales
#     resource :seller
#   end

# Sample resource route with more complex sub-resources
#   resources :products do
#     resources :comments
#     resources :sales do
#       get 'recent', :on => :collection
#     end
#   end

# Sample resource route within a namespace:
#   namespace :admin do
#     # Directs /admin/products/* to Admin::ProductsController
#     # (app/controllers/admin/products_controller.rb)
#     resources :products
#   end

# You can have the root of your site routed with "root"
# just remember to delete public/index.html.
# root :to => 'welcome#index'

# See how all your routes lay out with "rake routes"

# This is a legacy wild controller route that's not recommended for RESTful applications.
# Note: This route will make all actions in every controller accessible via GET requests.
# match ':controller(/:action(/:id))(.:format)'
end
