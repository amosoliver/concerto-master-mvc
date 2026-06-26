require "test_helper"

class MTonalidadesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_tonalidade = m_tonalidades(:one)
  end

  test "should get index" do
    get m_tonalidades_url
    assert_response :success
  end

  test "should get new" do
    get new_m_tonalidade_url
    assert_response :success
  end

  test "should create m_tonalidade" do
    assert_difference("MTonalidade.count") do
      post m_tonalidades_url, params: { m_tonalidade: { descricao: @m_tonalidade.descricao } }
    end

    assert_redirected_to m_tonalidade_url(MTonalidade.last)
  end

  test "should show m_tonalidade" do
    get m_tonalidade_url(@m_tonalidade)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_tonalidade_url(@m_tonalidade)
    assert_response :success
  end

  test "should update m_tonalidade" do
    patch m_tonalidade_url(@m_tonalidade), params: { m_tonalidade: { descricao: @m_tonalidade.descricao } }
    assert_redirected_to m_tonalidade_url(@m_tonalidade)
  end

  test "should destroy m_tonalidade" do
    assert_difference("MTonalidade.count", -1) do
      delete m_tonalidade_url(@m_tonalidade)
    end

    assert_redirected_to m_tonalidades_url
  end
end
