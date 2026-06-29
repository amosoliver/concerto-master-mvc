module CurrentContext
  extend ActiveSupport::Concern

  included do
    before_action :set_current_context

    helper_method :current_context,
                  :current_context_usuario,
                  :current_context_pessoa,
                  :current_context_entidade,
                  :current_context_entidade_base,
                  :current_context_entidades,
                  :current_context_entidade_ids,
                  :current_context_entidades_hierarquia
  end

  private

  def current_context
    Current
  end

  def current_context_usuario
    Current.g_usuario
  end

  def current_context_pessoa
    Current.g_pessoa
  end

  def current_context_entidade
    Current.g_entidade
  end

  def current_context_entidade_base
    Current.g_entidade_base
  end

  def current_context_entidades
    Current.g_entidades || GEntidade.none
  end

  def current_context_entidade_ids
    Current.g_entidade_ids || []
  end

  def current_context_entidades_hierarquia
    entidades = current_context_entidades.to_a
    return [] if entidades.empty?

    by_parent = entidades.group_by(&:g_entidade_id)
    roots = Array(by_parent[nil]).sort_by(&:descricao)
    roots = entidades.select { |entidade| !entidades.map(&:id).include?(entidade.g_entidade_id) }.sort_by(&:descricao) if roots.empty?

    build_entidade_tree(roots, by_parent)
  end

  def set_current_context
    return reset_current_context unless g_usuario_signed_in?

    usuario = current_g_usuario
    pessoa = usuario.g_pessoa
    entidade_base = pessoa&.g_entidade
    entidade_disponivel_ids = entidade_base ? entidade_base.self_and_descendant_ids : []
    entidades_disponiveis = GEntidade.where(id: entidade_disponivel_ids).order(:descricao)
    entidade = resolve_current_entidade(entidade_base, entidade_disponivel_ids)
    entidade_ids = entidade ? entidade.self_and_descendant_ids : []

    Current.g_usuario = usuario
    Current.g_pessoa = pessoa
    Current.g_entidade_base = entidade_base
    Current.g_entidade = entidade
    Current.g_entidade_ids = entidade_ids
    Current.g_entidades = entidades_disponiveis
    Current.g_instrumento_naipe_ids = pessoa&.g_instrumento_naipe_ids.to_a.uniq
  end

  def reset_current_context
    Current.reset
  end

  def resolve_current_entidade(entidade_base, entidade_disponivel_ids)
    return unless entidade_base

    entidade_id = session[:current_tenant_entity_id].presence&.to_i
    return entidade_base unless entidade_disponivel_ids.include?(entidade_id)

    GEntidade.find_by(id: entidade_id) || entidade_base
  end

  def build_entidade_tree(nodes, by_parent, level = 0, rows = [])
    nodes.each do |entidade|
      rows << { entidade: entidade, level: level, active: Current.g_entidade&.id == entidade.id }

      children = Array(by_parent[entidade.id]).sort_by(&:descricao)
      build_entidade_tree(children, by_parent, level + 1, rows) if children.any?
    end

    rows
  end
end
