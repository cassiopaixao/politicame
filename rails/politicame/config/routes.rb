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
  match 'ideia' => 'home#idea', :via => [:get]
  match 'proximos_passos' => 'home#next_steps', :via => [:get]
  match 'nota' => 'home#nota', :via => [:get]
  match 'assine' => 'home#subscribe', :via => [:post]
  get 'assine', :to => redirect('/')

  match 'importacao' => 'importacao_dados#index', :via => [:get]
  match 'importacao/proposicoes' => 'importacao_dados#proposicoes', :via => [:get]
  match 'importacao/proposicoes' => 'importacao_dados#fetch_proposicoes', :via => [:post]
  match 'importacao/votacoes' => 'importacao_dados#fetch_votacoes', :via => [:post]
  match 'importacao/votacoes/:tipo-:numero-:ano' => 'importacao_dados#fetch_votacoes_get', :via => [:get]
  match 'importacao/set_masters' => 'importacao_dados#votacoes', :via => [:get]
  match 'importacao/set_masters' => 'importacao_dados#set_masters', :via => [:post]
  match 'importacao/importar_deputados' => 'importacao_dados#importar_deputados', :via => [:get]
  match 'importacao/cadastrar_deputados' => 'importacao_dados#cadastrar_deputados', :via => [:get]

  match 'propostas/:tipo-:numero-:ano' => 'proposicao#show', :via => [:get], :constraints => {:tipo => /[A-Za-z]{2,3}/, :numero => /\d+/, :ano => /\d{4}/}
  match 'propostas/:tipo-:numero-:ano-:vote' => 'proposicao#register_vote', :via => [:get], :constraints => {:tipo => /[A-Za-z]{2,3}/, :numero => /\d+/, :ano => /\d{4}/}
  match 'propostas' => 'proposicao#index', :via => [:get]
  match 'propostas/rel-:tipo-:numero-:ano-:relevancia' => 'proposicao#register_relevance', :via => [:get]

  match 'ranking' => 'ranking#show', :via => [:get]
  match 'ranking' => 'ranking#show_filtered', :via => [:post]

  resources :deputados, :only => [:index, :show]
  match 'deputados' => 'deputados#index', :via => [:post]

  resources :videos, only: [:index, :show]
end
