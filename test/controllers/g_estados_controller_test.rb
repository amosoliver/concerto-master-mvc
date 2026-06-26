require "test_helper"

class GEstadosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @g_estado = g_estados(:one)
  end

  test "should get index" do
    get g_estados_url
    assert_response :success
  end

  test "should get new" do
    get new_g_estado_url
    assert_response :success
  end

  test "should create g_estado" do
    assert_difference("GEstado.count") do
      post g_estados_url, params: { g_estado: { codigo_ibge: @g_estado.codigo_ibge, descricao: @g_estado.descricao, g_pais_id: @g_estado.g_pais_id, sigla: @g_estado.sigla } }
    end

    assert_redirected_to g_estado_url(GEstado.last)
  end

  test "should show g_estado" do
    get g_estado_url(@g_estado)
    assert_response :success
  end

  test "should get edit" do
    get edit_g_estado_url(@g_estado)
    assert_response :success
  end

  test "should update g_estado" do
    patch g_estado_url(@g_estado), params: { g_estado: { codigo_ibge: @g_estado.codigo_ibge, descricao: @g_estado.descricao, g_pais_id: @g_estado.g_pais_id, sigla: @g_estado.sigla } }
    assert_redirected_to g_estado_url(@g_estado)
  end

  test "should destroy g_estado" do
    assert_difference("GEstado.count", -1) do
      delete g_estado_url(@g_estado)
    end

    assert_redirected_to g_estados_url
  end
end
