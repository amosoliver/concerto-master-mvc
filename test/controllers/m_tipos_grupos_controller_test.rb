require "test_helper"

class MTiposGruposControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_tipo_grupo = m_tipos_grupos(:one)
  end

  test "should get index" do
    get m_tipos_grupos_url
    assert_response :success
  end

  test "should get new" do
    get new_m_tipo_grupo_url
    assert_response :success
  end

  test "should create m_tipo_grupo" do
    assert_difference("MTipoGrupo.count") do
      post m_tipos_grupos_url, params: { m_tipo_grupo: { descricao: @m_tipo_grupo.descricao } }
    end

    assert_redirected_to m_tipo_grupo_url(MTipoGrupo.last)
  end

  test "should show m_tipo_grupo" do
    get m_tipo_grupo_url(@m_tipo_grupo)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_tipo_grupo_url(@m_tipo_grupo)
    assert_response :success
  end

  test "should update m_tipo_grupo" do
    patch m_tipo_grupo_url(@m_tipo_grupo), params: { m_tipo_grupo: { descricao: @m_tipo_grupo.descricao } }
    assert_redirected_to m_tipo_grupo_url(@m_tipo_grupo)
  end

  test "should destroy m_tipo_grupo" do
    assert_difference("MTipoGrupo.count", -1) do
      delete m_tipo_grupo_url(@m_tipo_grupo)
    end

    assert_redirected_to m_tipos_grupos_url
  end
end
