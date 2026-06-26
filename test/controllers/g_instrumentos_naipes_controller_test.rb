require "test_helper"

class GInstrumentosNaipesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @g_instrumento_naipe = g_instrumentos_naipes(:one)
  end

  test "should get index" do
    get g_instrumentos_naipes_url
    assert_response :success
  end

  test "should get new" do
    get new_g_instrumento_naipe_url
    assert_response :success
  end

  test "should create g_instrumento_naipe" do
    assert_difference("GInstrumentoNaipe.count") do
      post g_instrumentos_naipes_url, params: { g_instrumento_naipe: { g_instrumento_id: @g_instrumento_naipe.g_instrumento_id, g_naipe_id: @g_instrumento_naipe.g_naipe_id } }
    end

    assert_redirected_to g_instrumento_naipe_url(GInstrumentoNaipe.last)
  end

  test "should show g_instrumento_naipe" do
    get g_instrumento_naipe_url(@g_instrumento_naipe)
    assert_response :success
  end

  test "should get edit" do
    get edit_g_instrumento_naipe_url(@g_instrumento_naipe)
    assert_response :success
  end

  test "should update g_instrumento_naipe" do
    patch g_instrumento_naipe_url(@g_instrumento_naipe), params: { g_instrumento_naipe: { g_instrumento_id: @g_instrumento_naipe.g_instrumento_id, g_naipe_id: @g_instrumento_naipe.g_naipe_id } }
    assert_redirected_to g_instrumento_naipe_url(@g_instrumento_naipe)
  end

  test "should destroy g_instrumento_naipe" do
    assert_difference("GInstrumentoNaipe.count", -1) do
      delete g_instrumento_naipe_url(@g_instrumento_naipe)
    end

    assert_redirected_to g_instrumentos_naipes_url
  end
end
