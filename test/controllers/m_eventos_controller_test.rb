require "test_helper"

class MEventosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_evento = m_eventos(:one)
  end

  test "should get index" do
    get m_eventos_url
    assert_response :success
  end

  test "should get new" do
    get new_m_evento_url
    assert_response :success
  end

  test "should create m_evento" do
    assert_difference("MEvento.count") do
      post m_eventos_url, params: { m_evento: { data_fim: @m_evento.data_fim, data_inicio: @m_evento.data_inicio, descricao: @m_evento.descricao, g_predio_id: @m_evento.g_predio_id } }
    end

    assert_redirected_to m_evento_url(MEvento.last)
  end

  test "should show m_evento" do
    get m_evento_url(@m_evento)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_evento_url(@m_evento)
    assert_response :success
  end

  test "should update m_evento" do
    patch m_evento_url(@m_evento), params: { m_evento: { data_fim: @m_evento.data_fim, data_inicio: @m_evento.data_inicio, descricao: @m_evento.descricao, g_predio_id: @m_evento.g_predio_id } }
    assert_redirected_to m_evento_url(@m_evento)
  end

  test "should destroy m_evento" do
    assert_difference("MEvento.count", -1) do
      delete m_evento_url(@m_evento)
    end

    assert_redirected_to m_eventos_url
  end
end
