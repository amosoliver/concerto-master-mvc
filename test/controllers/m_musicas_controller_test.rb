require "test_helper"

class MMusicasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_musica = m_musicas(:one)
  end

  test "should get index" do
    get m_musicas_url
    assert_response :success
  end

  test "should get new" do
    get new_m_musica_url
    assert_response :success
  end

  test "should create m_musica" do
    assert_difference("MMusica.count") do
      post m_musicas_url, params: { m_musica: { descricao: @m_musica.descricao, m_artista_id: @m_musica.m_artista_id, m_compositor_id: @m_musica.m_compositor_id } }
    end

    assert_redirected_to m_musica_url(MMusica.last)
  end

  test "should show m_musica" do
    get m_musica_url(@m_musica)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_musica_url(@m_musica)
    assert_response :success
  end

  test "should update m_musica" do
    patch m_musica_url(@m_musica), params: { m_musica: { descricao: @m_musica.descricao, m_artista_id: @m_musica.m_artista_id, m_compositor_id: @m_musica.m_compositor_id } }
    assert_redirected_to m_musica_url(@m_musica)
  end

  test "should destroy m_musica" do
    assert_difference("MMusica.count", -1) do
      delete m_musica_url(@m_musica)
    end

    assert_redirected_to m_musicas_url
  end
end
