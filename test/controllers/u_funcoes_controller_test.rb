require "test_helper"

class UFuncoesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @u_funcao = u_funcoes(:one)
  end

  test "should get index" do
    get u_funcoes_url
    assert_response :success
  end

  test "should get new" do
    get new_u_funcao_url
    assert_response :success
  end

  test "should create u_funcao" do
    assert_difference("UFuncao.count") do
      post u_funcoes_url, params: { u_funcao: { descricao: @u_funcao.descricao, u_tipo_funcao_id: @u_funcao.u_tipo_funcao_id } }
    end

    assert_redirected_to u_funcao_url(UFuncao.last)
  end

  test "should show u_funcao" do
    get u_funcao_url(@u_funcao)
    assert_response :success
  end

  test "should get edit" do
    get edit_u_funcao_url(@u_funcao)
    assert_response :success
  end

  test "should update u_funcao" do
    patch u_funcao_url(@u_funcao), params: { u_funcao: { descricao: @u_funcao.descricao, u_tipo_funcao_id: @u_funcao.u_tipo_funcao_id } }
    assert_redirected_to u_funcao_url(@u_funcao)
  end

  test "should destroy u_funcao" do
    assert_difference("UFuncao.count", -1) do
      delete u_funcao_url(@u_funcao)
    end

    assert_redirected_to u_funcoes_url
  end
end
