require "test_helper"

class UTiposFuncoesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @u_tipo_funcao = u_tipos_funcoes(:one)
  end

  test "should get index" do
    get u_tipos_funcoes_url
    assert_response :success
  end

  test "should get new" do
    get new_u_tipo_funcao_url
    assert_response :success
  end

  test "should create u_tipo_funcao" do
    assert_difference("UTipoFuncao.count") do
      post u_tipos_funcoes_url, params: { u_tipo_funcao: { descricao: @u_tipo_funcao.descricao } }
    end

    assert_redirected_to u_tipo_funcao_url(UTipoFuncao.last)
  end

  test "should show u_tipo_funcao" do
    get u_tipo_funcao_url(@u_tipo_funcao)
    assert_response :success
  end

  test "should get edit" do
    get edit_u_tipo_funcao_url(@u_tipo_funcao)
    assert_response :success
  end

  test "should update u_tipo_funcao" do
    patch u_tipo_funcao_url(@u_tipo_funcao), params: { u_tipo_funcao: { descricao: @u_tipo_funcao.descricao } }
    assert_redirected_to u_tipo_funcao_url(@u_tipo_funcao)
  end

  test "should destroy u_tipo_funcao" do
    assert_difference("UTipoFuncao.count", -1) do
      delete u_tipo_funcao_url(@u_tipo_funcao)
    end

    assert_redirected_to u_tipos_funcoes_url
  end
end
