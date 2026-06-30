class HomeController < ApplicationController
  def index
    @dashboard_snapshot = DashboardResumoService.new(
      event_scope: tenant_scope(MEvento),
      ensaio_scope: tenant_scope(MEnsaio),
      pessoa_scope: tenant_scope(GPessoa),
      group_scope: tenant_scope(MGrupo),
      month_param: params[:month],
      view_param: params[:view],
      date_param: params[:date]
    ).call
  end

  def grupos
    @dashboard_snapshot = DashboardResumoService.new(
      event_scope: tenant_scope(MEvento),
      ensaio_scope: tenant_scope(MEnsaio),
      pessoa_scope: tenant_scope(GPessoa),
      group_scope: tenant_scope(MGrupo),
      month_param: params[:month],
      view_param: params[:view],
      date_param: params[:date]
    ).call
  end
end
