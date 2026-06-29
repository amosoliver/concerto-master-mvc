class TenantsController < ApplicationController
  def update
    entidade_id = tenant_params[:g_entidade_id].presence&.to_i
    allowed_ids = current_context_entidades.pluck(:id)

    if entidade_id.present? && allowed_ids.include?(entidade_id)
      session[:current_tenant_entity_id] = entidade_id
      redirect_back fallback_location: root_path, notice: "Entidade ativa alterada com sucesso."
    else
      redirect_back fallback_location: root_path, alert: "Entidade selecionada nao esta disponivel para o seu usuario."
    end
  end

  private

  def tenant_params
    params.require(:tenant).permit(:g_entidade_id)
  end
end
