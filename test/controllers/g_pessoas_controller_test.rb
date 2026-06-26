require "test_helper"

class GPessoasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @g_pessoa = g_pessoas(:one)
  end

  test "should get index" do
    get g_pessoas_url
    assert_response :success
  end

  test "should get new" do
    get new_g_pessoa_url
    assert_response :success
  end

  test "should create g_pessoa" do
    assert_difference("GPessoa.count") do
      post g_pessoas_url, params: { g_pessoa: { email: @g_pessoa.email, g_entidade_id: @g_pessoa.g_entidade_id, g_sexo_id: @g_pessoa.g_sexo_id, nome: @g_pessoa.nome } }
    end

    assert_redirected_to g_pessoa_url(GPessoa.last)
  end

  test "should show g_pessoa" do
    get g_pessoa_url(@g_pessoa)
    assert_response :success
  end

  test "should get edit" do
    get edit_g_pessoa_url(@g_pessoa)
    assert_response :success
  end

  test "should update g_pessoa" do
    patch g_pessoa_url(@g_pessoa), params: { g_pessoa: { email: @g_pessoa.email, g_entidade_id: @g_pessoa.g_entidade_id, g_sexo_id: @g_pessoa.g_sexo_id, nome: @g_pessoa.nome } }
    assert_redirected_to g_pessoa_url(@g_pessoa)
  end

  test "should destroy g_pessoa" do
    assert_difference("GPessoa.count", -1) do
      delete g_pessoa_url(@g_pessoa)
    end

    assert_redirected_to g_pessoas_url
  end
end
