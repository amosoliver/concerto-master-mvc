require "set"

class DashboardResumoService
  MONTH_FORMAT = "%Y-%m".freeze
  DATE_FORMAT = "%Y-%m-%d".freeze
  VIEWS = %w[month week day].freeze

  attr_reader :event_scope, :pessoa_scope, :group_scope, :month_param, :view, :anchor_date

  def initialize(event_scope:, pessoa_scope:, group_scope:, month_param:, view_param: nil, date_param: nil)
    @event_scope = event_scope
    @pessoa_scope = pessoa_scope
    @group_scope = group_scope
    @month_param = month_param
    @view = VIEWS.include?(view_param.to_s) ? view_param.to_s : "month"
    @anchor_date = parse_date(date_param) || Time.zone.today
  end

  def call
    {
      view: view,
      month_start: month_start,
      month_end: month_end,
      calendar_weeks: calendar_weeks,
      events_by_day: events_by_day,
      month_events: month_events,
      week_start: week_start,
      week_end: week_end,
      week_days: week_days,
      day: anchor_date,
      day_events: day_events,
      nav: nav,
      upcoming_events: upcoming_events,
      next_event: upcoming_events.first,
      stats: stats,
      naipe_breakdown: naipe_breakdown,
      instrument_breakdown: instrument_breakdown,
      voice_sections: voice_sections,
      group_sections: group_sections,
      people_total: loaded_people.size
    }
  end

  private

  def parse_date(value)
    Date.strptime(value.to_s, DATE_FORMAT)
  rescue ArgumentError
    nil
  end

  def month_start
    @month_start ||= begin
      parsed = Date.strptime(month_param.to_s, MONTH_FORMAT)
      parsed.beginning_of_month
    rescue ArgumentError
      Time.zone.today.beginning_of_month
    end
  end

  def month_end
    @month_end ||= month_start.end_of_month
  end

  def month_events
    @month_events ||= base_event_scope
      .where(data_inicio: month_start.beginning_of_day..month_end.end_of_day)
      .order(:data_inicio)
      .to_a
  end

  def week_start
    @week_start ||= anchor_date.beginning_of_week(:monday)
  end

  def week_end
    @week_end ||= anchor_date.end_of_week(:monday)
  end

  def week_days
    @week_days ||= (week_start..week_end).to_a
  end

  def week_events
    @week_events ||= base_event_scope
      .where(data_inicio: week_start.beginning_of_day..week_end.end_of_day)
      .order(:data_inicio)
      .to_a
  end

  def day_events
    @day_events ||= base_event_scope
      .where(data_inicio: anchor_date.beginning_of_day..anchor_date.end_of_day)
      .order(:data_inicio)
      .to_a
  end

  def events_by_day
    @events_by_day ||= case view
    when "week"
      week_events.group_by { |evento| evento.data_inicio.to_date }
    when "day"
      day_events.group_by { |evento| evento.data_inicio.to_date }
    else
      month_events.group_by { |evento| evento.data_inicio.to_date }
    end
  end

  def calendar_weeks
    first_day = month_start.beginning_of_week(:monday)
    last_day = month_end.end_of_week(:monday)

    (first_day..last_day).to_a.each_slice(7).to_a
  end

  def nav
    @nav ||= case view
    when "week"
      {
        today: { view: "week", date: Time.zone.today.strftime(DATE_FORMAT) },
        prev: { view: "week", date: (anchor_date - 7.days).strftime(DATE_FORMAT) },
        next: { view: "week", date: (anchor_date + 7.days).strftime(DATE_FORMAT) },
        switch_date: anchor_date.strftime(DATE_FORMAT),
        switch_month: anchor_date.beginning_of_month.strftime(MONTH_FORMAT)
      }
    when "day"
      {
        today: { view: "day", date: Time.zone.today.strftime(DATE_FORMAT) },
        prev: { view: "day", date: (anchor_date - 1.day).strftime(DATE_FORMAT) },
        next: { view: "day", date: (anchor_date + 1.day).strftime(DATE_FORMAT) },
        switch_date: anchor_date.strftime(DATE_FORMAT),
        switch_month: anchor_date.beginning_of_month.strftime(MONTH_FORMAT)
      }
    else
      {
        today: { view: "month", month: Time.zone.today.beginning_of_month.strftime(MONTH_FORMAT) },
        prev: { view: "month", month: month_start.prev_month.strftime(MONTH_FORMAT) },
        next: { view: "month", month: month_start.next_month.strftime(MONTH_FORMAT) },
        switch_date: month_start.strftime(DATE_FORMAT),
        switch_month: month_start.strftime(MONTH_FORMAT)
      }
    end
  end

  def upcoming_events
    @upcoming_events ||= base_event_scope
      .where("data_inicio >= ?", Time.zone.now.beginning_of_day)
      .order(:data_inicio)
      .limit(8)
      .to_a
  end

  def stats
    {
      eventos_mes: month_events.size,
      repertorio_mes: month_events.sum(&:repertorio_count),
      arranjos_mes: month_events.sum(&:arranjos_definidos_count),
      proximos_eventos: upcoming_events.size,
      grupos_ativos: group_sections.count { |group| group[:items].any? },
      vozes_ativas: voice_sections.count { |voice| voice[:people_names].any? }
    }
  end

  def naipe_breakdown
    @naipe_breakdown ||= build_breakdown_for do |instrumento_naipe|
      [instrumento_naipe.g_naipe_id, instrumento_naipe.g_naipe.to_s]
    end
  end

  def instrument_breakdown
    @instrument_breakdown ||= build_breakdown_for do |instrumento_naipe|
      [instrumento_naipe.g_instrumento_id, instrumento_naipe.g_instrumento.to_s]
    end
  end

  def group_sections
    @group_sections ||= loaded_groups.map do |group|
      grouped_items = Hash.new do |hash, key|
        hash[key] = { label: nil, card_label: nil, people_names: Set.new, voice_item: false }
      end

      group.g_pessoas.each do |pessoa|
        pessoa.g_instrumentos_naipes.each do |instrumento_naipe|
          entry = grouped_items[instrumento_naipe.id]
          entry[:label] = instrumento_naipe.to_s
          entry[:card_label] = group_card_label(group, instrumento_naipe)
          entry[:voice_item] = voice_instrument?(instrumento_naipe)
          entry[:people_names] << pessoa.nome
        end
      end

      {
        group_name: group.descricao,
        group_type: group.m_tipo_grupo&.to_s,
        people_count: group.g_pessoas.size,
        vocal_group: vocal_group?(group, grouped_items.values),
        items: grouped_items.values.map { |item|
          {
            label: item[:label],
            card_label: item[:card_label],
            count: item[:people_names].size,
            voice_item: item[:voice_item],
            people_names: item[:people_names].to_a.sort
          }
        }.sort_by { |item| [-item[:count], item[:card_label].to_s] }
      }
    end
  end

  def voice_sections
    @voice_sections ||= begin
      buckets = Hash.new do |hash, key|
        hash[key] = { label: nil, people_names: Set.new }
      end

      loaded_people.each do |pessoa|
        pessoa.g_instrumentos_naipes.each do |instrumento_naipe|
          next unless voice_instrument?(instrumento_naipe)

          bucket = buckets[instrumento_naipe.g_naipe_id]
          bucket[:label] = instrumento_naipe.g_naipe.to_s
          bucket[:people_names] << pessoa.nome
        end
      end

      buckets.values
        .map do |bucket|
          {
            label: bucket[:label],
            count: bucket[:people_names].size,
            people_names: bucket[:people_names].to_a.sort
          }
        end
        .sort_by { |item| [-item[:count], item[:label].to_s] }
    end
  end

  def build_breakdown_for
    buckets = Hash.new do |hash, key|
      hash[key] = { label: nil, people_ids: Set.new, people_names: Set.new }
    end

    loaded_people.each do |pessoa|
      pessoa.g_instrumentos_naipes.each do |instrumento_naipe|
        grouping_key, label = yield(instrumento_naipe)
        bucket = buckets[grouping_key]
        bucket[:label] = label
        bucket[:people_ids] << pessoa.id
        bucket[:people_names] << pessoa.nome
      end
    end

    buckets.values
      .map do |bucket|
        {
          label: bucket[:label],
          count: bucket[:people_ids].size,
          people_names: bucket[:people_names].to_a.sort
        }
      end
      .sort_by { |row| [-row[:count], row[:label].to_s] }
  end

  def base_event_scope
    @base_event_scope ||= event_scope.includes(:g_predio, :m_eventos_musicas)
  end

  def loaded_people
    @loaded_people ||= pessoa_scope.includes(g_instrumentos_naipes: %i[g_instrumento g_naipe]).to_a
  end

  def loaded_groups
    @loaded_groups ||= group_scope.includes(:m_tipo_grupo, g_pessoas: { g_instrumentos_naipes: %i[g_instrumento g_naipe] }).to_a
  end

  def voice_instrument?(instrumento_naipe)
    I18n.transliterate(instrumento_naipe.g_instrumento.to_s).downcase == "voz"
  end

  def vocal_group?(group, items)
    normalized_type = I18n.transliterate(group.m_tipo_grupo.to_s).downcase
    return true if normalized_type.include?("voz") || normalized_type.include?("coral")

    items.any? && items.all? { |item| item[:voice_item] }
  end

  def group_card_label(group, instrumento_naipe)
    return instrumento_naipe.g_naipe.to_s if vocal_group?(group, [{ voice_item: voice_instrument?(instrumento_naipe) }])

    instrumento_naipe.to_s
  end
end
