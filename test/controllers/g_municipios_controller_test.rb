require "test_helper"

class GMunicipiosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @g_municipio = g_municipios(:one)
  end

  test "should get index" do
    get g_municipios_url
    assert_response :success
  end

  test "should get new" do
    get new_g_municipio_url
    assert_response :success
  end

  test "should create g_municipio" do
    assert_difference("GMunicipio.count") do
      post g_municipios_url, params: { g_municipio: { codigo_ibge: @g_municipio.codigo_ibge, descricao: @g_municipio.descricao, g_estado_id: @g_municipio.g_estado_id } }
    end

    assert_redirected_to g_municipio_url(GMunicipio.last)
  end

  test "should show g_municipio" do
    get g_municipio_url(@g_municipio)
    assert_response :success
  end

  test "should get edit" do
    get edit_g_municipio_url(@g_municipio)
    assert_response :success
  end

  test "should update g_municipio" do
    patch g_municipio_url(@g_municipio), params: { g_municipio: { codigo_ibge: @g_municipio.codigo_ibge, descricao: @g_municipio.descricao, g_estado_id: @g_municipio.g_estado_id } }
    assert_redirected_to g_municipio_url(@g_municipio)
  end

  test "should destroy g_municipio" do
    assert_difference("GMunicipio.count", -1) do
      delete g_municipio_url(@g_municipio)
    end

    assert_redirected_to g_municipios_url
  end
end
