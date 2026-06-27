class ApplicationController < ActionController::Base
  include Authenticable
  include Pagy::Method
  include TenantAccess

  before_action :authenticate_g_usuario!, unless: :devise_controller?
  before_action { Pagy::I18n.locale = "pt-BR" }
  before_action :set_current_context
  before_action :redirect_primeiro_acesso!
  before_action :authorize_current_request!, unless: :authorization_skipped?

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  protected

  def after_sign_in_path_for(resource)
    return edit_g_usuario_registration_path if resource.is_a?(GUsuario) && resource.primeiro_acesso?

    super
  end

  private

  def set_current_context
    Current.g_usuario = current_g_usuario if g_usuario_signed_in?
  end

  def redirect_primeiro_acesso!
    return unless g_usuario_signed_in?
    return unless current_g_usuario.primeiro_acesso?
    return if devise_controller? && controller_name == "registrations"

    redirect_to edit_g_usuario_registration_path
  end
end
