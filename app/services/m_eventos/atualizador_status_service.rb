module MEventos
  class AtualizadorStatusService
    attr_reader :scope, :reference_time

    def initialize(scope: MEvento.all, reference_time: Time.current)
      @scope = scope
      @reference_time = reference_time
    end

    def call
      scope.find_each do |evento|
        next if evento.cancelado? || evento.finalizado?

        desired_status = status_for(evento)
        next if desired_status == evento.status_codigo

        evento.send(:apply_status!, desired_status, reference_time)
      end
    end

    private

    def status_for(evento)
      return evento.status_codigo if evento.data_inicio.blank?
      return MEvento::STATUS_AGENDADO if reference_time < evento.data_inicio
      return MEvento::STATUS_FINALIZADO if reference_time >= evento.cancelamento_limite_em

      MEvento::STATUS_EM_ANDAMENTO
    end
  end
end
