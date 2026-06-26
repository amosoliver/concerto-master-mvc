require "test_helper"

class GInstrumentosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @g_instrumento = g_instrumentos(:one)
  end

  test "should get index" do
    get g_instrumentos_url
    assert_response :success
  end

  test "should get new" do
    get new_g_instrumento_url
    assert_response :success
  end

  test "should create g_instrumento" do
    assert_difference("GInstrumento.count") do
      post g_instrumentos_url, params: { g_instrumento: { descricao: @g_instrumento.descricao } }
    end

    assert_redirected_to g_instrumento_url(GInstrumento.last)
  end

  test "should show g_instrumento" do
    get g_instrumento_url(@g_instrumento)
    assert_response :success
  end

  test "should get edit" do
    get edit_g_instrumento_url(@g_instrumento)
    assert_response :success
  end

  test "should update g_instrumento" do
    patch g_instrumento_url(@g_instrumento), params: { g_instrumento: { descricao: @g_instrumento.descricao } }
    assert_redirected_to g_instrumento_url(@g_instrumento)
  end

  test "should destroy g_instrumento" do
    assert_difference("GInstrumento.count", -1) do
      delete g_instrumento_url(@g_instrumento)
    end

    assert_redirected_to g_instrumentos_url
  end
end
