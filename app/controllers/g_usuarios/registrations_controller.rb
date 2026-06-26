class GUsuarios::RegistrationsController < Devise::RegistrationsController
  layout "devise"

  # Contas são criadas pelo administrador (CRUD de g_usuarios); não há autocadastro.
  before_action :block_self_registration, only: %i[new create destroy]

  protected

  def update_resource(resource, params)
    if resource.primeiro_acesso?
      resource.assign_attributes(params.except(:current_password))
      resource.primeiro_acesso = false if params[:password].present?
      resource.save
    else
      super
    end
  end

  def after_update_path_for(_resource)
    root_path
  end

  private

  def block_self_registration
    redirect_to root_path
  end
end
