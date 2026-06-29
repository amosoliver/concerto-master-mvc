require "test_helper"

class MEnsaiosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_ensaio = m_ensaios(:one)
  end

  test "should get index" do
    get m_ensaios_url
    assert_response :success
  end

  test "should get new" do
    get new_m_ensaio_url
    assert_response :success
  end

  test "should create m_ensaio" do
    assert_difference("MEnsaio.count") do
      post m_ensaios_url, params: { m_ensaio: { data_fim: @m_ensaio.data_fim, data_inicio: @m_ensaio.data_inicio, deleted_at: @m_ensaio.deleted_at, descricao: @m_ensaio.descricao, g_entidade_id: @m_ensaio.g_entidade_id, g_predio_id: @m_ensaio.g_predio_id } }
    end

    assert_redirected_to m_ensaio_url(MEnsaio.last)
  end

  test "should show m_ensaio" do
    get m_ensaio_url(@m_ensaio)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_ensaio_url(@m_ensaio)
    assert_response :success
  end

  test "should update m_ensaio" do
    patch m_ensaio_url(@m_ensaio), params: { m_ensaio: { data_fim: @m_ensaio.data_fim, data_inicio: @m_ensaio.data_inicio, deleted_at: @m_ensaio.deleted_at, descricao: @m_ensaio.descricao, g_entidade_id: @m_ensaio.g_entidade_id, g_predio_id: @m_ensaio.g_predio_id } }
    assert_redirected_to m_ensaio_url(@m_ensaio)
  end

  test "should destroy m_ensaio" do
    assert_difference("MEnsaio.count", -1) do
      delete m_ensaio_url(@m_ensaio)
    end

    assert_redirected_to m_ensaios_url
  end
end
