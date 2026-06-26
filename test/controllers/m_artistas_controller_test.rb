require "test_helper"

class MArtistasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_artista = m_artistas(:one)
  end

  test "should get index" do
    get m_artistas_url
    assert_response :success
  end

  test "should get new" do
    get new_m_artista_url
    assert_response :success
  end

  test "should create m_artista" do
    assert_difference("MArtista.count") do
      post m_artistas_url, params: { m_artista: { descricao: @m_artista.descricao } }
    end

    assert_redirected_to m_artista_url(MArtista.last)
  end

  test "should show m_artista" do
    get m_artista_url(@m_artista)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_artista_url(@m_artista)
    assert_response :success
  end

  test "should update m_artista" do
    patch m_artista_url(@m_artista), params: { m_artista: { descricao: @m_artista.descricao } }
    assert_redirected_to m_artista_url(@m_artista)
  end

  test "should destroy m_artista" do
    assert_difference("MArtista.count", -1) do
      delete m_artista_url(@m_artista)
    end

    assert_redirected_to m_artistas_url
  end
end
