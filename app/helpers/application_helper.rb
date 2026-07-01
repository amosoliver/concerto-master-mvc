module ApplicationHelper
  UI_ICONS = {
    home: '<path d="M5 12l-2 0l9 -9l9 9l-2 0" /><path d="M9 21v-6a2 2 0 0 1 2 -2h2a2 2 0 0 1 2 2v6" />',
    dashboard: '<path d="M4 4h6v8h-6z" /><path d="M14 4h6v5h-6z" /><path d="M14 13h6v7h-6z" /><path d="M4 16h6v4h-6z" />',
    chart_bar: '<path d="M3 12m0 1a1 1 0 0 1 1 -1h3a1 1 0 0 1 1 1v7a1 1 0 0 1 -1 1h-3a1 1 0 0 1 -1 -1z" /><path d="M10 8m0 1a1 1 0 0 1 1 -1h3a1 1 0 0 1 1 1v11a1 1 0 0 1 -1 1h-3a1 1 0 0 1 -1 -1z" /><path d="M17 4m0 1a1 1 0 0 1 1 -1h3a1 1 0 0 1 1 1v15a1 1 0 0 1 -1 1h-3a1 1 0 0 1 -1 -1z" />',
    compass: '<path d="M8 16l4 -8l8 -4l-4 8z" /><path d="M12 12l4 4" /><path d="M12 3a9 9 0 1 0 9 9" />',
    folders: '<path d="M4 19l16 0" /><path d="M4 4h5l3 3h8a1 1 0 0 1 1 1v8a2 2 0 0 1 -2 2h-13a2 2 0 0 1 -2 -2v-11a1 1 0 0 1 1 -1" />',
    world: '<path d="M3 12a9 9 0 1 0 18 0a9 9 0 0 0 -18 0" /><path d="M3.6 9h16.8" /><path d="M3.6 15h16.8" /><path d="M11.5 3a17 17 0 0 0 0 18" /><path d="M12.5 3a17 17 0 0 1 0 18" />',
    map: '<path d="M9 6l-6 3l0 11l6 -3l6 3l6 -3l0 -11l-6 3z" /><path d="M9 6l0 11" /><path d="M15 9l0 11" />',
    map_pin: '<path d="M9 12l0 .01" /><path d="M12 21s-6 -4.35 -6 -10a6 6 0 1 1 12 0c0 5.65 -6 10 -6 10" />',
    gender: '<path d="M10 14a4 4 0 1 0 0 -8a4 4 0 0 0 0 8z" /><path d="M10 14v7" /><path d="M7 18h6" /><path d="M21 3l-6 6" /><path d="M15 3h6v6" />',
    hierarchy: '<path d="M12 5m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0" /><path d="M5 19m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0" /><path d="M19 19m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0" /><path d="M12 7v5" /><path d="M5 17v-2a2 2 0 0 1 2 -2h10a2 2 0 0 1 2 2v2" />',
    building: '<path d="M3 21l18 0" /><path d="M5 21v-14l8 -4v18" /><path d="M19 21v-10l-6 -4" /><path d="M9 9l0 .01" /><path d="M9 12l0 .01" /><path d="M9 15l0 .01" /><path d="M17 13l0 .01" /><path d="M17 16l0 .01" />',
    building_bank: '<path d="M3 21l18 0" /><path d="M4 10l8 -4l8 4" /><path d="M5 10v11" /><path d="M9 10v11" /><path d="M15 10v11" /><path d="M19 10v11" />',
    user: '<path d="M8 7a4 4 0 1 0 8 0a4 4 0 0 0 -8 0" /><path d="M6 21v-2a4 4 0 0 1 4 -4h4a4 4 0 0 1 4 4v2" />',
    users: '<path d="M9 7a4 4 0 1 0 0 8a4 4 0 0 0 0 -8" /><path d="M17 11a4 4 0 1 0 0 .01" /><path d="M3 21v-2a4 4 0 0 1 4 -4h4" /><path d="M17 17h1a4 4 0 0 1 4 4v0" />',
    music: '<path d="M9 18a3 3 0 1 0 0 -6a3 3 0 0 0 0 6z" /><path d="M12 18V3l7 2v10" /><path d="M19 16a3 3 0 1 0 0 -6" />',
    calendar: '<path d="M4 7h16" /><path d="M8 3v4" /><path d="M16 3v4" /><path d="M5 4h14a2 2 0 0 1 2 2v12a2 2 0 0 1 -2 2h-14a2 2 0 0 1 -2 -2v-12a2 2 0 0 1 2 -2" />',
    note: '<path d="M9 18a3 3 0 1 0 0 -6a3 3 0 0 0 0 6z" /><path d="M12 18V6l8 -2v8" /><path d="M20 14a3 3 0 1 0 0 -6" />',
    key: '<path d="M16 11m-1 0a5 5 0 1 0 -10 0a5 5 0 0 0 10 0" /><path d="M20 11h-4" /><path d="M18 9l2 2l-2 2" />',
    id: '<path d="M5 7a2 2 0 0 1 2 -2h10a2 2 0 0 1 2 2v10a2 2 0 0 1 -2 2h-10a2 2 0 0 1 -2 -2z" /><path d="M9 10h.01" /><path d="M13 10h3" /><path d="M13 14h3" /><path d="M9 14a1.5 1.5 0 1 0 0 -3a1.5 1.5 0 0 0 0 3z" />',
    mail: '<path d="M3 7a2 2 0 0 1 2 -2h14a2 2 0 0 1 2 2v10a2 2 0 0 1 -2 2h-14a2 2 0 0 1 -2 -2z" /><path d="M3 7l9 6l9 -6" />',
    shield_lock: '<path d="M12 3l7 4v5c0 5 -3.5 8 -7 9c-3.5 -1 -7 -4 -7 -9v-5z" /><path d="M10 11a2 2 0 1 1 4 0v2h-4z" /><path d="M12 13v1" />',
    shield: '<path d="M12 3l7 4v5c0 5 -3.5 8 -7 9c-3.5 -1 -7 -4 -7 -9v-5z" />',
    plus: '<path d="M12 5l0 14" /><path d="M5 12l14 0" />',
    search: '<path d="M10 10m-7 0a7 7 0 1 0 14 0a7 7 0 1 0 -14 0" /><path d="M21 21l-6 -6" />',
    table: '<path d="M4 6a2 2 0 0 1 2 -2h12a2 2 0 0 1 2 2v12a2 2 0 0 1 -2 2h-12a2 2 0 0 1 -2 -2z" /><path d="M4 10h16" /><path d="M10 4v16" />',
    layout_grid: '<path d="M4 4h6v6h-6z" /><path d="M14 4h6v6h-6z" /><path d="M4 14h6v6h-6z" /><path d="M14 14h6v6h-6z" />',
    settings: '<path d="M12 9a3 3 0 1 0 0 6a3 3 0 0 0 0 -6" /><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06 .06a2 2 0 1 1 -2.83 2.83l-.06 -.06a1.65 1.65 0 0 0 -1.82 -.33a1.65 1.65 0 0 0 -1 1.51v.17a2 2 0 1 1 -4 0v-.17a1.65 1.65 0 0 0 -1 -1.51a1.65 1.65 0 0 0 -1.82 .33l-.06 .06a2 2 0 1 1 -2.83 -2.83l.06 -.06a1.65 1.65 0 0 0 .33 -1.82a1.65 1.65 0 0 0 -1.51 -1h-.17a2 2 0 1 1 0 -4h.17a1.65 1.65 0 0 0 1.51 -1a1.65 1.65 0 0 0 -.33 -1.82l-.06 -.06a2 2 0 1 1 2.83 -2.83l.06 .06a1.65 1.65 0 0 0 1.82 .33h.01a1.65 1.65 0 0 0 1 -1.51v-.17a2 2 0 1 1 4 0v.17a1.65 1.65 0 0 0 1 1.51h.01a1.65 1.65 0 0 0 1.82 -.33l.06 -.06a2 2 0 1 1 2.83 2.83l-.06 .06a1.65 1.65 0 0 0 -.33 1.82v.01a1.65 1.65 0 0 0 1.51 1h.17a2 2 0 1 1 0 4h-.17a1.65 1.65 0 0 0 -1.51 1z" />',
    eye: '<path d="M12 12m-2 0a2 2 0 1 0 4 0a2 2 0 0 0 -4 0" /><path d="M22 12c-2.2 4 -5.53 6 -10 6s-7.8 -2 -10 -6c2.2 -4 5.53 -6 10 -6s7.8 2 10 6" />',
    tool: '<path d="M14.7 6.3a3 3 0 0 0 -4 4l-6.7 6.7a2 2 0 1 0 2.8 2.8l6.7 -6.7a3 3 0 0 0 4 -4l-3 3l-2 -2z" />',
    pencil: '<path d="M4 20l4 -1l10 -10a2.828 2.828 0 1 0 -4 -4l-10 10l-1 4" /><path d="M13.5 6.5l4 4" />',
    trash: '<path d="M4 7l16 0" /><path d="M10 11l0 6" /><path d="M14 11l0 6" /><path d="M5 7l1 12a2 2 0 0 0 2 2h8a2 2 0 0 0 2 -2l1 -12" /><path d="M9 7v-3h6v3" />',
    moon: '<path d="M12 3c.132 0 .263 0 .393 .007a9 9 0 1 0 8.6 11.993a7 7 0 0 1 -8.993 -11.993z" />',
    sun: '<path d="M12 12m-4 0a4 4 0 1 0 8 0a4 4 0 1 0 -8 0" /><path d="M12 3l0 2" /><path d="M12 19l0 2" /><path d="M3 12l2 0" /><path d="M19 12l2 0" /><path d="M5.6 5.6l1.4 1.4" /><path d="M17 17l1.4 1.4" /><path d="M5.6 18.4l1.4 -1.4" /><path d="M17 7l1.4 -1.4" />',
    menu: '<path d="M4 8l16 0" /><path d="M4 12l16 0" /><path d="M4 16l16 0" />',
    x: '<path d="M18 6l-12 12" /><path d="M6 6l12 12" />',
    chevron_down: '<path d="M6 9l6 6l6 -6" />',
    logout: '<path d="M13 5l0 -1a2 2 0 0 0 -2 -2h-4a2 2 0 0 0 -2 2v16a2 2 0 0 0 2 2h4a2 2 0 0 0 2 -2v-1" /><path d="M16 17l5 -5l-5 -5" /><path d="M21 12h-13" />'
  }.freeze

  CALENDAR_MONTH_NAMES = [
    nil,
    "Janeiro",
    "Fevereiro",
    "Marco",
    "Abril",
    "Maio",
    "Junho",
    "Julho",
    "Agosto",
    "Setembro",
    "Outubro",
    "Novembro",
    "Dezembro"
  ].freeze

  CALENDAR_WEEKDAY_NAMES = [
    "Domingo",
    "Segunda-feira",
    "Terca-feira",
    "Quarta-feira",
    "Quinta-feira",
    "Sexta-feira",
    "Sabado"
  ].freeze

  BREADCRUMB_ACTION_LABELS = {
    "new" => "Novo",
    "edit" => "Editar",
    "manage" => "Gerenciar",
    "manage_arranjos" => "Arranjos",
    "manage_files" => "Arquivos",
    "grupos" => "Dashboard Pessoal",
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

  def calendar_month_label(date)
    "#{CALENDAR_MONTH_NAMES[date.month]} de #{date.year}"
  end

  def calendar_weekday_label(date)
    CALENDAR_WEEKDAY_NAMES[date.wday]
  end

  def calendar_period_label(view, snapshot)
    case view
    when "week"
      start_date = snapshot[:week_start]
      end_date = snapshot[:week_end]
      if start_date.month == end_date.month
        "#{start_date.day} a #{end_date.day} de #{CALENDAR_MONTH_NAMES[start_date.month]}"
      else
        "#{start_date.day} de #{CALENDAR_MONTH_NAMES[start_date.month]} a #{end_date.day} de #{CALENDAR_MONTH_NAMES[end_date.month]}"
      end
    when "day"
      date = snapshot[:day]
      "#{calendar_weekday_label(date)}, #{date.day} de #{CALENDAR_MONTH_NAMES[date.month]}"
    else
      calendar_month_label(snapshot[:month_start])
    end
  end

  def format_datetime(value, fallback: "-")
    return fallback if value.blank?

    I18n.l(value, format: "%d/%m/%Y %H:%M")
  end

  def format_time(value, fallback: "--:--")
    return fallback if value.blank?

    I18n.l(value, format: "%H:%M")
  end

  def format_timestamp(value, fallback: "-")
    format_datetime(value, fallback: fallback)
  end

  def format_datetime_range(start_at, end_at, fallback: "Pode definir depois")
    values = [start_at, end_at].compact
    return fallback if values.empty?

    values.map { |value| format_datetime(value) }.join(" até ")
  end

  def pagy_count_label(pagy, item_label: "registro")
    total = pagy&.count.to_i
    "#{total} #{item_label.pluralize(total)}"
  end

  def pagy_summary_text(pagy, item_label: "registro")
    return pagy_count_label(pagy, item_label: item_label) if pagy.blank?

    start_item = pagy.from || 0
    end_item = pagy.to || 0
    total = pagy.count || 0

    "Exibindo #{start_item}-#{end_item} de #{total} #{item_label.pluralize(total)}"
  end

  def calendar_entry_path(entry)
    entry[:kind] == :ensaio ? m_ensaio_path(entry[:record]) : m_evento_path(entry[:record])
  end

  def calendar_entry_type_label(entry)
    entry[:kind] == :ensaio ? "Ensaio" : "Evento"
  end

  def calendar_entry_css_class(entry)
    entry[:kind] == :ensaio ? "is-ensaio" : "is-evento"
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
      nav_item(model_plural_human_name(GPais), :world, g_paises_path, "g_paises"),
      nav_item(model_plural_human_name(GEstado), :map, g_estados_path, "g_estados"),
      nav_item(model_plural_human_name(GMunicipio), :map_pin, g_municipios_path, "g_municipios")
    ]

    referencial_classificacoes = [
      nav_item(model_plural_human_name(GSexo), :gender, g_sexos_path, "g_sexos"),
      nav_item(model_plural_human_name(GInstrumentoNaipe), :hierarchy, g_instrumentos_naipes_path, "g_instrumentos_naipes")
    ]

    gestao_pessoas_entidades = [
      nav_item(model_plural_human_name(GEntidade), :building, g_entidades_path, "g_entidades"),
      nav_item(model_plural_human_name(GPredio), :building_bank, g_predios_path, "g_predios"),
      nav_item(model_plural_human_name(GPessoa), :user, g_pessoas_path, "g_pessoas"),
      nav_item(model_plural_human_name(MGrupo), :users, m_grupos_path, "m_grupos")
    ]

    musica_catalogo = [
      nav_item(model_plural_human_name(MMusica), :music, m_musicas_path, "m_musicas"),
      nav_item(model_plural_human_name(MEvento), :calendar, m_eventos_path, "m_eventos"),
      nav_item(model_plural_human_name(MEnsaio), :note, m_ensaios_path, "m_ensaios")
    ]

    acesso_items = [
      nav_item(model_plural_human_name(GUsuario), :key, g_usuarios_path, "g_usuarios"),
      nav_item(model_plural_human_name(UPerfil), :id, u_perfis_path, "u_perfis"),
      nav_item(model_plural_human_name(UPermissao), :shield_lock, u_permissoes_path, "u_permissoes")
    ]

    dashboards_items = [
      nav_item("Visão Geral", :chart_bar, root_path, "home"),
      nav_item("Pessoal", :users, dashboard_grupos_path, "home")
    ]

    [
      nav_group("Dashboards", :dashboard, items: dashboards_items),
      nav_group("Referencial", :compass, items: referencial_localizacao + referencial_classificacoes),
      nav_group("Gestão", :folders, items: gestao_pessoas_entidades),
      nav_group("Música", :note, items: musica_catalogo),
      nav_group("Acesso", :shield, items: acesso_items)
    ].filter_map do |group|
      filtered_items = Array(group[:items]).select { |item| allowed_action?(item[:controller], "index") }
      next if filtered_items.blank?

      group.merge(items: filtered_items)
    end
  end

  def current_user_has_instrument_assignments?
    current_user_assigned_instrument_ids.any?
  end

  def current_user_admin_for_current_entity?
    current_g_usuario&.admin_for?(current_context_entidade)
  end

  def current_user_assigned_instrument_ids
    Current.g_instrumento_naipe_ids || []
  end

  def current_user_group_ids_for_entity
    return [] unless current_context_pessoa.present?

    @current_user_group_ids_for_entity ||= current_context_pessoa.m_grupos.where(g_entidade_id: current_context_entidade_ids).pluck(:id)
  end

  def evento_musica_visible_for_current_user?(evento_musica)
    return false if evento_musica.blank?
    return true if current_user_admin_for_current_entity?

    grupo_ids = evento_musica.m_grupos.map(&:id)
    return true if grupo_ids.empty?

    (grupo_ids & current_user_group_ids_for_entity).any?
  end

  def instrument_relations_for_current_user(arranjo)
    return [] if arranjo.blank?
    return [] if current_user_assigned_instrument_ids.blank?

    arranjo.m_arranjos_instrumentos_naipes.select do |relation|
      current_user_assigned_instrument_ids.include?(relation.g_instrumento_naipe_id)
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

  def ui_icon(name, size: 18, stroke: 1.8, classes: nil)
    body = UI_ICONS[name.to_sym]
    return unless body

    content_tag(
      :svg,
      body.html_safe,
      xmlns: "http://www.w3.org/2000/svg",
      width: size,
      height: size,
      viewBox: "0 0 24 24",
      fill: "none",
      stroke: "currentColor",
      "stroke-width": stroke,
      "stroke-linecap": "round",
      "stroke-linejoin": "round",
      class: ["ui-icon", classes].compact.join(" "),
      aria: { hidden: true }
    )
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
