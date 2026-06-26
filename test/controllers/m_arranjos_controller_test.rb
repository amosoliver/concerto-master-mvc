require "test_helper"

class MArranjosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_arranjo = m_arranjos(:one)
  end

  test "should get index" do
    get m_arranjos_url
    assert_response :success
  end

  test "should get new" do
    get new_m_arranjo_url
    assert_response :success
  end

  test "should create m_arranjo" do
    assert_difference("MArranjo.count") do
      post m_arranjos_url, params: { m_arranjo: { m_arranjador_id: @m_arranjo.m_arranjador_id, m_musica_id: @m_arranjo.m_musica_id, m_tonalidade_id: @m_arranjo.m_tonalidade_id } }
    end

    assert_redirected_to m_arranjo_url(MArranjo.last)
  end

  test "should show m_arranjo" do
    get m_arranjo_url(@m_arranjo)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_arranjo_url(@m_arranjo)
    assert_response :success
  end

  test "should update m_arranjo" do
    patch m_arranjo_url(@m_arranjo), params: { m_arranjo: { m_arranjador_id: @m_arranjo.m_arranjador_id, m_musica_id: @m_arranjo.m_musica_id, m_tonalidade_id: @m_arranjo.m_tonalidade_id } }
    assert_redirected_to m_arranjo_url(@m_arranjo)
  end

  test "should destroy m_arranjo" do
    assert_difference("MArranjo.count", -1) do
      delete m_arranjo_url(@m_arranjo)
    end

    assert_redirected_to m_arranjos_url
  end
end
