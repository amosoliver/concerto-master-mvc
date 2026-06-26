require "test_helper"

class GPaisesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @g_pais = g_paises(:one)
  end

  test "should get index" do
    get g_paises_url
    assert_response :success
  end

  test "should get new" do
    get new_g_pais_url
    assert_response :success
  end

  test "should create g_pais" do
    assert_difference("GPais.count") do
      post g_paises_url, params: { g_pais: { descricao: @g_pais.descricao } }
    end

    assert_redirected_to g_pais_url(GPais.last)
  end

  test "should show g_pais" do
    get g_pais_url(@g_pais)
    assert_response :success
  end

  test "should get edit" do
    get edit_g_pais_url(@g_pais)
    assert_response :success
  end

  test "should update g_pais" do
    patch g_pais_url(@g_pais), params: { g_pais: { descricao: @g_pais.descricao } }
    assert_redirected_to g_pais_url(@g_pais)
  end

  test "should destroy g_pais" do
    assert_difference("GPais.count", -1) do
      delete g_pais_url(@g_pais)
    end

    assert_redirected_to g_paises_url
  end
end
