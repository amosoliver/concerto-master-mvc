require "test_helper"

class GPessoasInstrumentosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @g_pessoas_instrumento = g_pessoas_instrumentos(:one)
  end

  test "should get index" do
    get g_pessoas_instrumentos_url
    assert_response :success
  end

  test "should get new" do
    get new_g_pessoas_instrumento_url
    assert_response :success
  end

  test "should create g_pessoas_instrumento" do
    assert_difference("GPessoasInstrumento.count") do
      post g_pessoas_instrumentos_url, params: { g_pessoas_instrumento: { g_instrumento_naipe_id: @g_pessoas_instrumento.g_instrumento_naipe_id, g_pessoa_id: @g_pessoas_instrumento.g_pessoa_id } }
    end

    assert_redirected_to g_pessoas_instrumento_url(GPessoasInstrumento.last)
  end

  test "should show g_pessoas_instrumento" do
    get g_pessoas_instrumento_url(@g_pessoas_instrumento)
    assert_response :success
  end

  test "should get edit" do
    get edit_g_pessoas_instrumento_url(@g_pessoas_instrumento)
    assert_response :success
  end

  test "should update g_pessoas_instrumento" do
    patch g_pessoas_instrumento_url(@g_pessoas_instrumento), params: { g_pessoas_instrumento: { g_instrumento_naipe_id: @g_pessoas_instrumento.g_instrumento_naipe_id, g_pessoa_id: @g_pessoas_instrumento.g_pessoa_id } }
    assert_redirected_to g_pessoas_instrumento_url(@g_pessoas_instrumento)
  end

  test "should destroy g_pessoas_instrumento" do
    assert_difference("GPessoasInstrumento.count", -1) do
      delete g_pessoas_instrumento_url(@g_pessoas_instrumento)
    end

    assert_redirected_to g_pessoas_instrumentos_url
  end
end
