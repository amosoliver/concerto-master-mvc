require "test_helper"

class UPerfisFuncoesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @u_perfil_funcao = u_perfis_funcoes(:one)
  end

  test "should get index" do
    get u_perfis_funcoes_url
    assert_response :success
  end

  test "should get new" do
    get new_u_perfil_funcao_url
    assert_response :success
  end

  test "should create u_perfil_funcao" do
    assert_difference("UPerfilFuncao.count") do
      post u_perfis_funcoes_url, params: { u_perfil_funcao: { u_funcao_id: @u_perfil_funcao.u_funcao_id, u_perfil_id: @u_perfil_funcao.u_perfil_id } }
    end

    assert_redirected_to u_perfil_funcao_url(UPerfilFuncao.last)
  end

  test "should show u_perfil_funcao" do
    get u_perfil_funcao_url(@u_perfil_funcao)
    assert_response :success
  end

  test "should get edit" do
    get edit_u_perfil_funcao_url(@u_perfil_funcao)
    assert_response :success
  end

  test "should update u_perfil_funcao" do
    patch u_perfil_funcao_url(@u_perfil_funcao), params: { u_perfil_funcao: { u_funcao_id: @u_perfil_funcao.u_funcao_id, u_perfil_id: @u_perfil_funcao.u_perfil_id } }
    assert_redirected_to u_perfil_funcao_url(@u_perfil_funcao)
  end

  test "should destroy u_perfil_funcao" do
    assert_difference("UPerfilFuncao.count", -1) do
      delete u_perfil_funcao_url(@u_perfil_funcao)
    end

    assert_redirected_to u_perfis_funcoes_url
  end
end
