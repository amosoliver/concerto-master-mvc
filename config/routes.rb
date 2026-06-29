Rails.application.routes.draw do
  resource :tenant, only: :update
  resources :m_ensaio_musicas
  resources :m_ensaios
  devise_for :g_usuarios, controllers: { sessions: "g_usuarios/sessions", registrations: "g_usuarios/registrations" }

  resources :m_eventos_musicas
  resources :m_eventos
  resources :m_arranjos_instrumentos_naipes
  resources :m_tipos_arranjos
  resources :m_arranjos do
    member do
      get :manage_files
      patch :update_files
    end
  end
  resources :m_arranjadores
  resources :m_tonalidades
  resources :m_musicas do
    member do
      get :manage_arranjos
    end
  end
  resources :m_artistas
  resources :m_compositores
  resources :m_grupos_pessoas
  resources :m_grupos do
    member do
      get :manage
      patch :update_management
    end
  end
  resources :m_tipos_grupos
  resources :g_pessoas_instrumentos
  resources :g_instrumentos_naipes
  resources :g_naipes
  resources :g_instrumentos
  resources :m_pessoas_funcoes
  resources :u_perfis_funcoes
  resources :u_funcoes
  resources :u_tipos_funcoes
  resources :u_usuarios_perfis
  resources :u_perfis_permissoes
  resources :u_permissoes do
    collection do
      post :atualizar
    end
  end
  resources :u_perfis
  resources :g_usuarios
  resources :g_pessoas
  resources :g_predios
  resources :g_entidades
  resources :g_municipios
  resources :g_estados
  resources :g_paises
  resources :g_sexos
  get "up" => "rails/health#show", as: :rails_health_check

  resources :examples

  root "home#index"
end
