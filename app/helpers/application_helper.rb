module ApplicationHelper
  BREADCRUMB_ACTION_LABELS = {
    "new" => "Novo",
    "edit" => "Editar",
    "manage" => "Gerenciar",
    "manage_arranjos" => "Arranjos",
    "manage_files" => "Arquivos",
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

  AUDIO_FILE_EXTENSIONS = %w[
    3ga 8svx aac aif aifc aiff alac amr ape au caf cda dff dsf
    flac gsm it m4a m4b m4p mid midi mod monkey mp1 mp2 mp3 mpa
    mpc oga ogg opus ra ram snd spx tak tta voc vox wav weba wma
    wv xm
  ].freeze

  def audio_attachment_file?(attachment_or_blob)
    blob = extract_attachment_blob(attachment_or_blob)
    return false unless blob

    content_type = blob.content_type.to_s.downcase
    filename = blob.filename.to_s
    extension = File.extname(filename).delete('.').downcase

    content_type.start_with?('audio/') || AUDIO_FILE_EXTENSIONS.include?(extension)
  end

  def previewable_attachment_file?(attachment_or_blob)
    blob = extract_attachment_blob(attachment_or_blob)
    return false unless blob

    blob.image? || blob.content_type.to_s.downcase == 'application/pdf'
  end

  def attachment_label(attachment_or_blob)
    blob = extract_attachment_blob(attachment_or_blob)
    return "arquivo" unless blob

    content_type = blob.content_type.to_s.downcase
    extension = File.extname(blob.filename.to_s).delete('.').downcase

    return "PDF" if content_type == 'application/pdf' || extension == 'pdf'

    content_type.presence || extension.upcase.presence || "arquivo"
  end

  def extract_attachment_blob(attachment_or_blob)
    return if attachment_or_blob.blank?

    return attachment_or_blob if attachment_or_blob.is_a?(ActiveStorage::Blob)
    return attachment_or_blob.blob if attachment_or_blob.respond_to?(:blob)

    if attachment_or_blob.respond_to?(:attached?) && attachment_or_blob.attached?
      return attachment_or_blob.attachments.first&.blob if attachment_or_blob.respond_to?(:attachments)
      return attachment_or_blob.blob if attachment_or_blob.respond_to?(:blob)
    end

    nil
  end

  def sidebar_nav_groups
    referencial_localizacao = [
      nav_item(model_plural_human_name(GPais), "🌎", g_paises_path, "g_paises"),
      nav_item(model_plural_human_name(GEstado), "🗺️", g_estados_path, "g_estados"),
      nav_item(model_plural_human_name(GMunicipio), "📍", g_municipios_path, "g_municipios")
    ]

    referencial_classificacoes = [
      nav_item(model_plural_human_name(GSexo), "⚧️", g_sexos_path, "g_sexos"),
      nav_item(model_plural_human_name(GInstrumentoNaipe), "🔗", g_instrumentos_naipes_path, "g_instrumentos_naipes"),
      nav_item(model_plural_human_name(MTipoArranjo), "🧩", m_tipos_arranjos_path, "m_tipos_arranjos"),
      nav_item(model_plural_human_name(MTonalidade), "🎹", m_tonalidades_path, "m_tonalidades")
    ]

    gestao_pessoas_entidades = [
      nav_item(model_plural_human_name(GEntidade), "🏢", g_entidades_path, "g_entidades"),
      nav_item(model_plural_human_name(GPredio), "🏛️", g_predios_path, "g_predios"),
      nav_item(model_plural_human_name(GPessoa), "👤", g_pessoas_path, "g_pessoas"),
      nav_item(model_plural_human_name(MGrupo), "👥", m_grupos_path, "m_grupos"),
      nav_item(model_plural_human_name(MTipoGrupo), "🏷️", m_tipos_grupos_path, "m_tipos_grupos")
    ]

    musica_catalogo = [
      nav_item(model_plural_human_name(MMusica), "🎵", m_musicas_path, "m_musicas"),
      nav_item(model_plural_human_name(MEvento), "📅", m_eventos_path, "m_eventos")
    ]

    acesso_items = [
      nav_item(model_plural_human_name(GUsuario), "🔑", g_usuarios_path, "g_usuarios"),
      nav_item(model_plural_human_name(UPerfil), "🪪", u_perfis_path, "u_perfis"),
      nav_item(model_plural_human_name(UFuncao), "🎖️", u_funcoes_path, "u_funcoes"),
      nav_item(model_plural_human_name(UTipoFuncao), "🏷️", u_tipos_funcoes_path, "u_tipos_funcoes"),
      nav_item(model_plural_human_name(UPermissao), "🛡️", u_permissoes_path, "u_permissoes")
    ]

    [
      { items: [nav_item("Dashboard", "📊", root_path, "home")] },
      nav_group("Referencial", "🧭", items: referencial_localizacao + referencial_classificacoes),
      nav_group("Gestão", "🗂️", items: gestao_pessoas_entidades),
      nav_group("Música", "🎼", items: musica_catalogo),
      nav_group("Acesso", "🔐", items: acesso_items),
      { items: [nav_item(model_plural_human_name(Example), "🧪", examples_path, "examples")] }
    ].filter_map do |group|
      filtered_items = Array(group[:items]).select { |item| allowed_action?(item[:controller], "index") }
      next if filtered_items.blank?

      group.merge(items: filtered_items)
    end
  end

  def authorized_link_to(name = nil, options = nil, html_options = nil, &block)
    target = block_given? ? name : options
    method = extract_authorized_link_method(block_given? ? options : html_options)
    return unless allowed_path?(target, method: method)

    return link_to(name, options, &block) if block_given?

    link_to(name, options, html_options)
  end

  def authorized_button_to(name = nil, options = nil, html_options = nil, &block)
    target = block_given? ? name : options
    method = extract_authorized_button_method(block_given? ? options : html_options)
    return unless allowed_path?(target, method: method)

    return button_to(name, options, &block) if block_given?

    button_to(name, options, html_options)
  end

  private

  def nav_item(label, icon, path, controller)
    { label: label, icon: icon, path: path, controller: controller }
  end

  def nav_group(label, icon, items: [])
    {
      label: label,
      icon: icon,
      items: items,
      expanded: nav_collection_active?(items)
    }
  end

  def nav_collection_active?(items)
    items.any? { |item| item[:controller] == controller_name }
  end

  def extract_authorized_link_method(html_options)
    return :get unless html_options.respond_to?(:to_h)

    options_hash = html_options.to_h
    options_hash[:method] || options_hash.dig(:data, :turbo_method) || :get
  end

  def extract_authorized_button_method(html_options)
    return :post unless html_options.respond_to?(:to_h)

    html_options.to_h[:method] || :post
  end
end
