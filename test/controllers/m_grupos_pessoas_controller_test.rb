require "test_helper"

class MGruposPessoasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_grupo_pessoa = m_grupos_pessoas(:one)
  end

  test "should get index" do
    get m_grupos_pessoas_url
    assert_response :success
  end

  test "should get new" do
    get new_m_grupo_pessoa_url
    assert_response :success
  end

  test "should create m_grupo_pessoa" do
    assert_difference("MGrupoPessoa.count") do
      post m_grupos_pessoas_url, params: { m_grupo_pessoa: { g_pessoa_id: @m_grupo_pessoa.g_pessoa_id, m_grupo_id: @m_grupo_pessoa.m_grupo_id } }
    end

    assert_redirected_to m_grupo_pessoa_url(MGrupoPessoa.last)
  end

  test "should show m_grupo_pessoa" do
    get m_grupo_pessoa_url(@m_grupo_pessoa)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_grupo_pessoa_url(@m_grupo_pessoa)
    assert_response :success
  end

  test "should update m_grupo_pessoa" do
    patch m_grupo_pessoa_url(@m_grupo_pessoa), params: { m_grupo_pessoa: { g_pessoa_id: @m_grupo_pessoa.g_pessoa_id, m_grupo_id: @m_grupo_pessoa.m_grupo_id } }
    assert_redirected_to m_grupo_pessoa_url(@m_grupo_pessoa)
  end

  test "should destroy m_grupo_pessoa" do
    assert_difference("MGrupoPessoa.count", -1) do
      delete m_grupo_pessoa_url(@m_grupo_pessoa)
    end

    assert_redirected_to m_grupos_pessoas_url
  end
end
