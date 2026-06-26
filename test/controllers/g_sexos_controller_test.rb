require "test_helper"

class GSexosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @g_sexo = g_sexos(:one)
  end

  test "should get index" do
    get g_sexos_url
    assert_response :success
  end

  test "should get new" do
    get new_g_sexo_url
    assert_response :success
  end

  test "should create g_sexo" do
    assert_difference("GSexo.count") do
      post g_sexos_url, params: { g_sexo: { descricao: @g_sexo.descricao } }
    end

    assert_redirected_to g_sexo_url(GSexo.last)
  end

  test "should show g_sexo" do
    get g_sexo_url(@g_sexo)
    assert_response :success
  end

  test "should get edit" do
    get edit_g_sexo_url(@g_sexo)
    assert_response :success
  end

  test "should update g_sexo" do
    patch g_sexo_url(@g_sexo), params: { g_sexo: { descricao: @g_sexo.descricao } }
    assert_redirected_to g_sexo_url(@g_sexo)
  end

  test "should destroy g_sexo" do
    assert_difference("GSexo.count", -1) do
      delete g_sexo_url(@g_sexo)
    end

    assert_redirected_to g_sexos_url
  end
end
