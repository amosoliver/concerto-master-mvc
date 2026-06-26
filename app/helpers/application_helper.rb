module ApplicationHelper
  BREADCRUMB_ACTION_LABELS = {
    "new" => "Novo",
    "edit" => "Editar",
    "show" => "Detalhes"
  }.freeze

  # Derived purely from controller_path/action_name so scaffolded
  # controllers get a breadcrumb without any per-view setup.
  def breadcrumbs
    return [] if controller_path == "home"

    crumbs = [{ label: "Início", path: root_path }]

    model = controller_path.classify.safe_constantize
    resource_label = model ? model_plural_human_name(model) : controller_path.humanize
    index_path = begin
      url_for(controller: controller_path, action: :index, only_path: true)
    rescue ActionController::UrlGenerationError
      nil
    end

    if action_name == "index"
      crumbs << { label: resource_label, path: nil }
    else
      crumbs << { label: resource_label, path: index_path }
      crumbs << { label: BREADCRUMB_ACTION_LABELS.fetch(action_name, action_name.humanize), path: nil }
    end

    crumbs
  end

  # Uses the real pt-BR plural translation when a model defines one
  # (activerecord.models.<model>.other); falls back to a naive pluralize
  # for models that haven't been translated yet.
  def model_plural_human_name(model)
    singular = model.model_name.human
    plural = model.model_name.human(count: 2)
    plural == singular ? plural.pluralize : plural
  end

  def sidebar_nav_items
    [
      { label: "Dashboard", icon: "◉", path: root_path, controller: "home" },
      { label: "G Entidades", icon: "◌", path: g_entidades_path, controller: "g_entidades" },
      { label: "G Estados", icon: "◌", path: g_estados_path, controller: "g_estados" },
      { label: "G Instrumentos", icon: "◌", path: g_instrumentos_path, controller: "g_instrumentos" },
      { label: "G Instrumentos Naipes", icon: "◌", path: g_instrumentos_naipes_path, controller: "g_instrumentos_naipes" },
      { label: "G Municípios", icon: "◌", path: g_municipios_path, controller: "g_municipios" },
      { label: "G Naipes", icon: "◌", path: g_naipes_path, controller: "g_naipes" },
      { label: "G Países", icon: "◌", path: g_paises_path, controller: "g_paises" },
      { label: "G Pessoas", icon: "◌", path: g_pessoas_path, controller: "g_pessoas" },
      { label: "G Pessoas Instrumentos", icon: "◌", path: g_pessoas_instrumentos_path, controller: "g_pessoas_instrumentos" },
      { label: "G Prédios", icon: "◌", path: g_predios_path, controller: "g_predios" },
      { label: "G Sexos", icon: "◌", path: g_sexos_path, controller: "g_sexos" },
      { label: "G Usuários", icon: "◌", path: g_usuarios_path, controller: "g_usuarios" },
      { label: "M Arranjadores", icon: "◌", path: m_arranjadores_path, controller: "m_arranjadores" },
      { label: "M Arranjos", icon: "◌", path: m_arranjos_path, controller: "m_arranjos" },
      { label: "M Arranjos Instrumentos Naipes", icon: "◌", path: m_arranjos_instrumentos_naipes_path, controller: "m_arranjos_instrumentos_naipes" },
      { label: "M Artistas", icon: "◌", path: m_artistas_path, controller: "m_artistas" },
      { label: "M Compositores", icon: "◌", path: m_compositores_path, controller: "m_compositores" },
      { label: "M Eventos", icon: "◌", path: m_eventos_path, controller: "m_eventos" },
      { label: "M Eventos Músicas", icon: "◌", path: m_eventos_musicas_path, controller: "m_eventos_musicas" },
      { label: "M Grupos", icon: "◌", path: m_grupos_path, controller: "m_grupos" },
      { label: "M Grupos Pessoas", icon: "◌", path: m_grupos_pessoas_path, controller: "m_grupos_pessoas" },
      { label: "M Músicas", icon: "◌", path: m_musicas_path, controller: "m_musicas" },
      { label: "M Pessoas Funções", icon: "◌", path: m_pessoas_funcoes_path, controller: "m_pessoas_funcoes" },
      { label: "M Tipos Grupos", icon: "◌", path: m_tipos_grupos_path, controller: "m_tipos_grupos" },
      { label: "M Tonalidades", icon: "◌", path: m_tonalidades_path, controller: "m_tonalidades" },
      { label: "U Funções", icon: "◌", path: u_funcoes_path, controller: "u_funcoes" },
      { label: "U Perfis", icon: "◌", path: u_perfis_path, controller: "u_perfis" },
      { label: "U Perfis Funções", icon: "◌", path: u_perfis_funcoes_path, controller: "u_perfis_funcoes" },
      { label: "U Perfis Permissões", icon: "◌", path: u_perfis_permissoes_path, controller: "u_perfis_permissoes" },
      { label: "U Permissões", icon: "◌", path: u_permissoes_path, controller: "u_permissoes" },
      { label: "U Tipos Funções", icon: "◌", path: u_tipos_funcoes_path, controller: "u_tipos_funcoes" },
      { label: "U Usuários Perfis", icon: "◌", path: u_usuarios_perfis_path, controller: "u_usuarios_perfis" },
      { label: "Exemplos", icon: "◌", path: examples_path, controller: "examples" }
    ]
  end
end
