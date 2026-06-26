require "test_helper"

class UUsuariosPerfisControllerTest < ActionDispatch::IntegrationTest
  setup do
    @u_usuario_perfil = u_usuarios_perfis(:one)
  end

  test "should get index" do
    get u_usuarios_perfis_url
    assert_response :success
  end

  test "should get new" do
    get new_u_usuario_perfil_url
    assert_response :success
  end

  test "should create u_usuario_perfil" do
    assert_difference("UUsuarioPerfil.count") do
      post u_usuarios_perfis_url, params: { u_usuario_perfil: { g_usuario_id: @u_usuario_perfil.g_usuario_id, u_perfil_id: @u_usuario_perfil.u_perfil_id } }
    end

    assert_redirected_to u_usuario_perfil_url(UUsuarioPerfil.last)
  end

  test "should show u_usuario_perfil" do
    get u_usuario_perfil_url(@u_usuario_perfil)
    assert_response :success
  end

  test "should get edit" do
    get edit_u_usuario_perfil_url(@u_usuario_perfil)
    assert_response :success
  end

  test "should update u_usuario_perfil" do
    patch u_usuario_perfil_url(@u_usuario_perfil), params: { u_usuario_perfil: { g_usuario_id: @u_usuario_perfil.g_usuario_id, u_perfil_id: @u_usuario_perfil.u_perfil_id } }
    assert_redirected_to u_usuario_perfil_url(@u_usuario_perfil)
  end

  test "should destroy u_usuario_perfil" do
    assert_difference("UUsuarioPerfil.count", -1) do
      delete u_usuario_perfil_url(@u_usuario_perfil)
    end

    assert_redirected_to u_usuarios_perfis_url
  end
end
