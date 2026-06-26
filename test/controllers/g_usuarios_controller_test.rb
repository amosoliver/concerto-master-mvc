require "test_helper"

class GUsuariosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @g_usuario = g_usuarios(:one)
  end

  test "should get index" do
    get g_usuarios_url
    assert_response :success
  end

  test "should get new" do
    get new_g_usuario_url
    assert_response :success
  end

  test "should create g_usuario" do
    assert_difference("GUsuario.count") do
      post g_usuarios_url, params: { g_usuario: { ativo: @g_usuario.ativo, email: @g_usuario.email, encrypted_password: @g_usuario.encrypted_password, g_pessoa_id: @g_usuario.g_pessoa_id } }
    end

    assert_redirected_to g_usuario_url(GUsuario.last)
  end

  test "should show g_usuario" do
    get g_usuario_url(@g_usuario)
    assert_response :success
  end

  test "should get edit" do
    get edit_g_usuario_url(@g_usuario)
    assert_response :success
  end

  test "should update g_usuario" do
    patch g_usuario_url(@g_usuario), params: { g_usuario: { ativo: @g_usuario.ativo, email: @g_usuario.email, encrypted_password: @g_usuario.encrypted_password, g_pessoa_id: @g_usuario.g_pessoa_id } }
    assert_redirected_to g_usuario_url(@g_usuario)
  end

  test "should destroy g_usuario" do
    assert_difference("GUsuario.count", -1) do
      delete g_usuario_url(@g_usuario)
    end

    assert_redirected_to g_usuarios_url
  end
end
