require "test_helper"

class MEventosMusicasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_evento_musica = m_eventos_musicas(:one)
  end

  test "should get index" do
    get m_eventos_musicas_url
    assert_response :success
  end

  test "should get new" do
    get new_m_evento_musica_url
    assert_response :success
  end

  test "should create m_evento_musica" do
    assert_difference("MEventoMusica.count") do
      post m_eventos_musicas_url, params: { m_evento_musica: { m_evento_id: @m_evento_musica.m_evento_id, m_musica_id: @m_evento_musica.m_musica_id } }
    end

    assert_redirected_to m_evento_musica_url(MEventoMusica.last)
  end

  test "should show m_evento_musica" do
    get m_evento_musica_url(@m_evento_musica)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_evento_musica_url(@m_evento_musica)
    assert_response :success
  end

  test "should update m_evento_musica" do
    patch m_evento_musica_url(@m_evento_musica), params: { m_evento_musica: { m_evento_id: @m_evento_musica.m_evento_id, m_musica_id: @m_evento_musica.m_musica_id } }
    assert_redirected_to m_evento_musica_url(@m_evento_musica)
  end

  test "should destroy m_evento_musica" do
    assert_difference("MEventoMusica.count", -1) do
      delete m_evento_musica_url(@m_evento_musica)
    end

    assert_redirected_to m_eventos_musicas_url
  end
end
