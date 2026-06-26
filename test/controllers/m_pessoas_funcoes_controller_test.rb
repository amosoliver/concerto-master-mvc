require "test_helper"

class MPessoasFuncoesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_pessoa_funcao = m_pessoas_funcoes(:one)
  end

  test "should get index" do
    get m_pessoas_funcoes_url
    assert_response :success
  end

  test "should get new" do
    get new_m_pessoa_funcao_url
    assert_response :success
  end

  test "should create m_pessoa_funcao" do
    assert_difference("MPessoaFuncao.count") do
      post m_pessoas_funcoes_url, params: { m_pessoa_funcao: { g_pessoa_id: @m_pessoa_funcao.g_pessoa_id, principal: @m_pessoa_funcao.principal, u_funcao_id: @m_pessoa_funcao.u_funcao_id } }
    end

    assert_redirected_to m_pessoa_funcao_url(MPessoaFuncao.last)
  end

  test "should show m_pessoa_funcao" do
    get m_pessoa_funcao_url(@m_pessoa_funcao)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_pessoa_funcao_url(@m_pessoa_funcao)
    assert_response :success
  end

  test "should update m_pessoa_funcao" do
    patch m_pessoa_funcao_url(@m_pessoa_funcao), params: { m_pessoa_funcao: { g_pessoa_id: @m_pessoa_funcao.g_pessoa_id, principal: @m_pessoa_funcao.principal, u_funcao_id: @m_pessoa_funcao.u_funcao_id } }
    assert_redirected_to m_pessoa_funcao_url(@m_pessoa_funcao)
  end

  test "should destroy m_pessoa_funcao" do
    assert_difference("MPessoaFuncao.count", -1) do
      delete m_pessoa_funcao_url(@m_pessoa_funcao)
    end

    assert_redirected_to m_pessoas_funcoes_url
  end
end
