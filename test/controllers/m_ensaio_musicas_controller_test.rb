require "test_helper"

class MEnsaioMusicasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_ensaio_musica = m_ensaio_musicas(:one)
  end

  test "should get index" do
    get m_ensaio_musicas_url
    assert_response :success
  end

  test "should get new" do
    get new_m_ensaio_musica_url
    assert_response :success
  end

  test "should create m_ensaio_musica" do
    assert_difference("MEnsaioMusica.count") do
      post m_ensaio_musicas_url, params: { m_ensaio_musica: { deleted_at: @m_ensaio_musica.deleted_at, g_entidade_id: @m_ensaio_musica.g_entidade_id, m_ensaio_id: @m_ensaio_musica.m_ensaio_id, m_evento_musica_id: @m_ensaio_musica.m_evento_musica_id, observacao: @m_ensaio_musica.observacao } }
    end

    assert_redirected_to m_ensaio_musica_url(MEnsaioMusica.last)
  end

  test "should show m_ensaio_musica" do
    get m_ensaio_musica_url(@m_ensaio_musica)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_ensaio_musica_url(@m_ensaio_musica)
    assert_response :success
  end

  test "should update m_ensaio_musica" do
    patch m_ensaio_musica_url(@m_ensaio_musica), params: { m_ensaio_musica: { deleted_at: @m_ensaio_musica.deleted_at, g_entidade_id: @m_ensaio_musica.g_entidade_id, m_ensaio_id: @m_ensaio_musica.m_ensaio_id, m_evento_musica_id: @m_ensaio_musica.m_evento_musica_id, observacao: @m_ensaio_musica.observacao } }
    assert_redirected_to m_ensaio_musica_url(@m_ensaio_musica)
  end

  test "should destroy m_ensaio_musica" do
    assert_difference("MEnsaioMusica.count", -1) do
      delete m_ensaio_musica_url(@m_ensaio_musica)
    end

    assert_redirected_to m_ensaio_musicas_url
  end
end
