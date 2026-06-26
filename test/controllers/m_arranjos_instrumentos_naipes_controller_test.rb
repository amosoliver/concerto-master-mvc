require "test_helper"

class MArranjosInstrumentosNaipesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_arranjo_instrumento_naipe = m_arranjos_instrumentos_naipes(:one)
  end

  test "should get index" do
    get m_arranjos_instrumentos_naipes_url
    assert_response :success
  end

  test "should get new" do
    get new_m_arranjo_instrumento_naipe_url
    assert_response :success
  end

  test "should create m_arranjo_instrumento_naipe" do
    assert_difference("MArranjoInstrumentoNaipe.count") do
      post m_arranjos_instrumentos_naipes_url, params: { m_arranjo_instrumento_naipe: { g_instrumento_naipe_id: @m_arranjo_instrumento_naipe.g_instrumento_naipe_id, m_arranjo_id: @m_arranjo_instrumento_naipe.m_arranjo_id } }
    end

    assert_redirected_to m_arranjo_instrumento_naipe_url(MArranjoInstrumentoNaipe.last)
  end

  test "should show m_arranjo_instrumento_naipe" do
    get m_arranjo_instrumento_naipe_url(@m_arranjo_instrumento_naipe)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_arranjo_instrumento_naipe_url(@m_arranjo_instrumento_naipe)
    assert_response :success
  end

  test "should update m_arranjo_instrumento_naipe" do
    patch m_arranjo_instrumento_naipe_url(@m_arranjo_instrumento_naipe), params: { m_arranjo_instrumento_naipe: { g_instrumento_naipe_id: @m_arranjo_instrumento_naipe.g_instrumento_naipe_id, m_arranjo_id: @m_arranjo_instrumento_naipe.m_arranjo_id } }
    assert_redirected_to m_arranjo_instrumento_naipe_url(@m_arranjo_instrumento_naipe)
  end

  test "should destroy m_arranjo_instrumento_naipe" do
    assert_difference("MArranjoInstrumentoNaipe.count", -1) do
      delete m_arranjo_instrumento_naipe_url(@m_arranjo_instrumento_naipe)
    end

    assert_redirected_to m_arranjos_instrumentos_naipes_url
  end
end
