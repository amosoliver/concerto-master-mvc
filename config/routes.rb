Rails.application.routes.draw do
  get "dashboard/grupos", to: "home#grupos", as: :dashboard_grupos
  resource :tenant, only: :update
  resources :m_ensaios
  devise_for :g_usuarios, controllers: { sessions: "g_usuarios/sessions", registrations: "g_usuarios/registrations" }

  resources :m_eventos do
    member do
      get :manage
      patch :update_management
    end
  end
  resources :m_arranjos do
    member do
      get :manage_files
      patch :update_files
    end
  end
  resources :m_musicas do
    member do
      get :manage_arranjos
    end
  end
  resources :m_grupos do
    member do
      get :manage
      patch :update_management
    end
  end
  resources :g_instrumentos_naipes
  resources :u_permissoes do
    collection do
      post :atualizar
    end
  end
  resources :u_perfis
  resources :g_usuarios do
    member do
      get :manage_perfis
      patch :update_perfis
    end
  end
  resources :g_pessoas
  resources :g_predios
  resources :g_entidades
  resources :g_municipios
  resources :g_estados
  resources :g_paises
  resources :g_sexos
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
end
