require "test_helper"

class GPrediosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @g_predio = g_predios(:one)
  end

  test "should get index" do
    get g_predios_url
    assert_response :success
  end

  test "should get new" do
    get new_g_predio_url
    assert_response :success
  end

  test "should create g_predio" do
    assert_difference("GPredio.count") do
      post g_predios_url, params: { g_predio: { bairro: @g_predio.bairro, cep: @g_predio.cep, g_entidade_id: @g_predio.g_entidade_id, logradouro: @g_predio.logradouro, nome_fantasia: @g_predio.nome_fantasia } }
    end

    assert_redirected_to g_predio_url(GPredio.last)
  end

  test "should show g_predio" do
    get g_predio_url(@g_predio)
    assert_response :success
  end

  test "should get edit" do
    get edit_g_predio_url(@g_predio)
    assert_response :success
  end

  test "should update g_predio" do
    patch g_predio_url(@g_predio), params: { g_predio: { bairro: @g_predio.bairro, cep: @g_predio.cep, g_entidade_id: @g_predio.g_entidade_id, logradouro: @g_predio.logradouro, nome_fantasia: @g_predio.nome_fantasia } }
    assert_redirected_to g_predio_url(@g_predio)
  end

  test "should destroy g_predio" do
    assert_difference("GPredio.count", -1) do
      delete g_predio_url(@g_predio)
    end

    assert_redirected_to g_predios_url
  end
end
