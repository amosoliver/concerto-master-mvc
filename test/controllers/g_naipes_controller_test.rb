require "test_helper"

class GNaipesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @g_naipe = g_naipes(:one)
  end

  test "should get index" do
    get g_naipes_url
    assert_response :success
  end

  test "should get new" do
    get new_g_naipe_url
    assert_response :success
  end

  test "should create g_naipe" do
    assert_difference("GNaipe.count") do
      post g_naipes_url, params: { g_naipe: { descricao: @g_naipe.descricao } }
    end

    assert_redirected_to g_naipe_url(GNaipe.last)
  end

  test "should show g_naipe" do
    get g_naipe_url(@g_naipe)
    assert_response :success
  end

  test "should get edit" do
    get edit_g_naipe_url(@g_naipe)
    assert_response :success
  end

  test "should update g_naipe" do
    patch g_naipe_url(@g_naipe), params: { g_naipe: { descricao: @g_naipe.descricao } }
    assert_redirected_to g_naipe_url(@g_naipe)
  end

  test "should destroy g_naipe" do
    assert_difference("GNaipe.count", -1) do
      delete g_naipe_url(@g_naipe)
    end

    assert_redirected_to g_naipes_url
  end
end
