module MEventosHelper
  def m_evento_status_badge_class(m_evento)
    case m_evento.status_codigo
    when MEvento::STATUS_AGENDADO
      "status-badge--info"
    when MEvento::STATUS_EM_ANDAMENTO
      "status-badge--warning"
    when MEvento::STATUS_FINALIZADO
      "status-badge--success"
    when MEvento::STATUS_CANCELADO
      "status-badge--danger"
    else
      "status-badge--muted"
    end
  end

  def m_evento_status_label(m_evento)
    m_evento.status_descricao
  end
end
