require "test_helper"

class UPerfisPermissoesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @u_perfil_permissao = u_perfis_permissoes(:one)
  end

  test "should get index" do
    get u_perfis_permissoes_url
    assert_response :success
  end

  test "should get new" do
    get new_u_perfil_permissao_url
    assert_response :success
  end

  test "should create u_perfil_permissao" do
    assert_difference("UPerfilPermissao.count") do
      post u_perfis_permissoes_url, params: { u_perfil_permissao: { u_perfil_id: @u_perfil_permissao.u_perfil_id, u_permissao_id: @u_perfil_permissao.u_permissao_id } }
    end

    assert_redirected_to u_perfil_permissao_url(UPerfilPermissao.last)
  end

  test "should show u_perfil_permissao" do
    get u_perfil_permissao_url(@u_perfil_permissao)
    assert_response :success
  end

  test "should get edit" do
    get edit_u_perfil_permissao_url(@u_perfil_permissao)
    assert_response :success
  end

  test "should update u_perfil_permissao" do
    patch u_perfil_permissao_url(@u_perfil_permissao), params: { u_perfil_permissao: { u_perfil_id: @u_perfil_permissao.u_perfil_id, u_permissao_id: @u_perfil_permissao.u_permissao_id } }
    assert_redirected_to u_perfil_permissao_url(@u_perfil_permissao)
  end

  test "should destroy u_perfil_permissao" do
    assert_difference("UPerfilPermissao.count", -1) do
      delete u_perfil_permissao_url(@u_perfil_permissao)
    end

    assert_redirected_to u_perfis_permissoes_url
  end
end
