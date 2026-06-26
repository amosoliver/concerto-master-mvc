require "test_helper"

class GEntidadesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @g_entidade = g_entidades(:one)
  end

  test "should get index" do
    get g_entidades_url
    assert_response :success
  end

  test "should get new" do
    get new_g_entidade_url
    assert_response :success
  end

  test "should create g_entidade" do
    assert_difference("GEntidade.count") do
      post g_entidades_url, params: { g_entidade: { descricao: @g_entidade.descricao, g_estado_id: @g_entidade.g_estado_id, g_municipio_id: @g_entidade.g_municipio_id } }
    end

    assert_redirected_to g_entidade_url(GEntidade.last)
  end

  test "should show g_entidade" do
    get g_entidade_url(@g_entidade)
    assert_response :success
  end

  test "should get edit" do
    get edit_g_entidade_url(@g_entidade)
    assert_response :success
  end

  test "should update g_entidade" do
    patch g_entidade_url(@g_entidade), params: { g_entidade: { descricao: @g_entidade.descricao, g_estado_id: @g_entidade.g_estado_id, g_municipio_id: @g_entidade.g_municipio_id } }
    assert_redirected_to g_entidade_url(@g_entidade)
  end

  test "should destroy g_entidade" do
    assert_difference("GEntidade.count", -1) do
      delete g_entidade_url(@g_entidade)
    end

    assert_redirected_to g_entidades_url
  end
end
