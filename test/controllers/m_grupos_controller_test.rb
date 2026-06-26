require "test_helper"

class MGruposControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_grupo = m_grupos(:one)
  end

  test "should get index" do
    get m_grupos_url
    assert_response :success
  end

  test "should get new" do
    get new_m_grupo_url
    assert_response :success
  end

  test "should create m_grupo" do
    assert_difference("MGrupo.count") do
      post m_grupos_url, params: { m_grupo: { descricao: @m_grupo.descricao, g_entidade_id: @m_grupo.g_entidade_id, m_tipo_grupo_id: @m_grupo.m_tipo_grupo_id } }
    end

    assert_redirected_to m_grupo_url(MGrupo.last)
  end

  test "should show m_grupo" do
    get m_grupo_url(@m_grupo)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_grupo_url(@m_grupo)
    assert_response :success
  end

  test "should update m_grupo" do
    patch m_grupo_url(@m_grupo), params: { m_grupo: { descricao: @m_grupo.descricao, g_entidade_id: @m_grupo.g_entidade_id, m_tipo_grupo_id: @m_grupo.m_tipo_grupo_id } }
    assert_redirected_to m_grupo_url(@m_grupo)
  end

  test "should destroy m_grupo" do
    assert_difference("MGrupo.count", -1) do
      delete m_grupo_url(@m_grupo)
    end

    assert_redirected_to m_grupos_url
  end
end
