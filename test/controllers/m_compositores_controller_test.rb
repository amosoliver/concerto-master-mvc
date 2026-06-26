require "test_helper"

class MCompositoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_compositor = m_compositores(:one)
  end

  test "should get index" do
    get m_compositores_url
    assert_response :success
  end

  test "should get new" do
    get new_m_compositor_url
    assert_response :success
  end

  test "should create m_compositor" do
    assert_difference("MCompositor.count") do
      post m_compositores_url, params: { m_compositor: { descricao: @m_compositor.descricao } }
    end

    assert_redirected_to m_compositor_url(MCompositor.last)
  end

  test "should show m_compositor" do
    get m_compositor_url(@m_compositor)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_compositor_url(@m_compositor)
    assert_response :success
  end

  test "should update m_compositor" do
    patch m_compositor_url(@m_compositor), params: { m_compositor: { descricao: @m_compositor.descricao } }
    assert_redirected_to m_compositor_url(@m_compositor)
  end

  test "should destroy m_compositor" do
    assert_difference("MCompositor.count", -1) do
      delete m_compositor_url(@m_compositor)
    end

    assert_redirected_to m_compositores_url
  end
end
