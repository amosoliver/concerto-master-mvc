namespace :m_evento_statuses do
  desc "Popula os status padrao de eventos"
  task populate: :environment do
    MEventoStatus::TODOS.each do |codigo, descricao|
      status = MEventoStatus.with_discarded.find_or_initialize_by(codigo: codigo)
      status.descricao = descricao
      status.deleted_at = nil
      status.save!
    end
  end
end
