require "test_helper"

class MArranjadoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_arranjador = m_arranjadores(:one)
  end

  test "should get index" do
    get m_arranjadores_url
    assert_response :success
  end

  test "should get new" do
    get new_m_arranjador_url
    assert_response :success
  end

  test "should create m_arranjador" do
    assert_difference("MArranjador.count") do
      post m_arranjadores_url, params: { m_arranjador: { descricao: @m_arranjador.descricao } }
    end

    assert_redirected_to m_arranjador_url(MArranjador.last)
  end

  test "should show m_arranjador" do
    get m_arranjador_url(@m_arranjador)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_arranjador_url(@m_arranjador)
    assert_response :success
  end

  test "should update m_arranjador" do
    patch m_arranjador_url(@m_arranjador), params: { m_arranjador: { descricao: @m_arranjador.descricao } }
    assert_redirected_to m_arranjador_url(@m_arranjador)
  end

  test "should destroy m_arranjador" do
    assert_difference("MArranjador.count", -1) do
      delete m_arranjador_url(@m_arranjador)
    end

    assert_redirected_to m_arranjadores_url
  end
end
