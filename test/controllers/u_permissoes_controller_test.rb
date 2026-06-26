require "test_helper"

class UPermissoesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @u_permissao = u_permissoes(:one)
  end

  test "should get index" do
    get u_permissoes_url
    assert_response :success
  end

  test "should get new" do
    get new_u_permissao_url
    assert_response :success
  end

  test "should create u_permissao" do
    assert_difference("UPermissao.count") do
      post u_permissoes_url, params: { u_permissao: { acao: @u_permissao.acao, admin: @u_permissao.admin, controlador: @u_permissao.controlador, descricao: @u_permissao.descricao } }
    end

    assert_redirected_to u_permissao_url(UPermissao.last)
  end

  test "should show u_permissao" do
    get u_permissao_url(@u_permissao)
    assert_response :success
  end

  test "should get edit" do
    get edit_u_permissao_url(@u_permissao)
    assert_response :success
  end

  test "should update u_permissao" do
    patch u_permissao_url(@u_permissao), params: { u_permissao: { acao: @u_permissao.acao, admin: @u_permissao.admin, controlador: @u_permissao.controlador, descricao: @u_permissao.descricao } }
    assert_redirected_to u_permissao_url(@u_permissao)
  end

  test "should destroy u_permissao" do
    assert_difference("UPermissao.count", -1) do
      delete u_permissao_url(@u_permissao)
    end

    assert_redirected_to u_permissoes_url
  end
end
