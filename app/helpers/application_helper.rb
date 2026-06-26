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

  # cpf/cep are stored unmasked (digits only); these format them for display
  # only, mirroring the live input mask used while typing in the forms.
  def format_cpf(value)
    return if value.blank?

    value.gsub(/(\d{3})(\d{3})(\d{3})(\d{2})/, '\1.\2.\3-\4')
  end

  def format_cep(value)
    return if value.blank?

    value.gsub(/(\d{5})(\d{3})/, '\1-\2')
  end

  # Sidebar structure: a list of groups. Each group either renders its
  # `items` directly (no header) or splits them into labeled `subgroups`.
  # Association/join tables (no identity of their own, just linking two
  # entities) all share the same "link" icon so the icon language stays
  # meaningful instead of forcing a unique icon onto every junction table.
  def sidebar_nav_groups
    [
      { items: [nav_item("Dashboard", "📊", root_path, "home")] },
      {
        label: "Geral",
        subgroups: [
          {
            label: "Localização",
            items: [
              nav_item(model_plural_human_name(GPais), "🌎", g_paises_path, "g_paises"),
              nav_item(model_plural_human_name(GEstado), "🗺️", g_estados_path, "g_estados"),
              nav_item(model_plural_human_name(GMunicipio), "📍", g_municipios_path, "g_municipios")
            ]
          },
          {
            label: "Pessoas e Entidades",
            items: [
              nav_item(model_plural_human_name(GEntidade), "🏢", g_entidades_path, "g_entidades"),
              nav_item(model_plural_human_name(GPredio), "🏛️", g_predios_path, "g_predios"),
              nav_item(model_plural_human_name(GPessoa), "👤", g_pessoas_path, "g_pessoas"),
              nav_item(model_plural_human_name(GSexo), "⚧️", g_sexos_path, "g_sexos"),
              nav_item(model_plural_human_name(GPessoasInstrumento), "🔗", g_pessoas_instrumentos_path, "g_pessoas_instrumentos")
            ]
          },
          {
            label: "Instrumentos",
            items: [
              nav_item(model_plural_human_name(GInstrumento), "🎸", g_instrumentos_path, "g_instrumentos"),
              nav_item(model_plural_human_name(GNaipe), "🎻", g_naipes_path, "g_naipes"),
              nav_item(model_plural_human_name(GInstrumentoNaipe), "🔗", g_instrumentos_naipes_path, "g_instrumentos_naipes")
            ]
          }
        ]
      },
      {
        label: "Música",
        subgroups: [
          {
            label: "Catálogo",
            items: [
              nav_item(model_plural_human_name(MMusica), "🎵", m_musicas_path, "m_musicas"),
              nav_item(model_plural_human_name(MArtista), "🎤", m_artistas_path, "m_artistas"),
              nav_item(model_plural_human_name(MCompositor), "✍️", m_compositores_path, "m_compositores"),
              nav_item(model_plural_human_name(MTonalidade), "🎹", m_tonalidades_path, "m_tonalidades"),
              nav_item(model_plural_human_name(MArranjador), "🎚️", m_arranjadores_path, "m_arranjadores"),
              nav_item(model_plural_human_name(MArranjo), "🎼", m_arranjos_path, "m_arranjos"),
              nav_item(model_plural_human_name(MArranjoInstrumentoNaipe), "🔗", m_arranjos_instrumentos_naipes_path, "m_arranjos_instrumentos_naipes")
            ]
          },
          {
            label: "Eventos",
            items: [
              nav_item(model_plural_human_name(MEvento), "📅", m_eventos_path, "m_eventos"),
              nav_item(model_plural_human_name(MEventoMusica), "🔗", m_eventos_musicas_path, "m_eventos_musicas")
            ]
          },
          {
            label: "Grupos",
            items: [
              nav_item(model_plural_human_name(MGrupo), "👥", m_grupos_path, "m_grupos"),
              nav_item(model_plural_human_name(MTipoGrupo), "🏷️", m_tipos_grupos_path, "m_tipos_grupos"),
              nav_item(model_plural_human_name(MGrupoPessoa), "🔗", m_grupos_pessoas_path, "m_grupos_pessoas"),
              nav_item(model_plural_human_name(MPessoaFuncao), "🔗", m_pessoas_funcoes_path, "m_pessoas_funcoes")
            ]
          }
        ]
      },
      {
        label: "Acesso",
        items: [
          nav_item(model_plural_human_name(GUsuario), "🔑", g_usuarios_path, "g_usuarios"),
          nav_item(model_plural_human_name(UPerfil), "🪪", u_perfis_path, "u_perfis"),
          nav_item(model_plural_human_name(UFuncao), "🎖️", u_funcoes_path, "u_funcoes"),
          nav_item(model_plural_human_name(UTipoFuncao), "🏷️", u_tipos_funcoes_path, "u_tipos_funcoes"),
          nav_item(model_plural_human_name(UPermissao), "🛡️", u_permissoes_path, "u_permissoes")
        ]
      },
      { items: [nav_item(model_plural_human_name(Example), "🧪", examples_path, "examples")] }
    ]
  end

  private

  def nav_item(label, icon, path, controller)
    { label: label, icon: icon, path: path, controller: controller }
  end
end
