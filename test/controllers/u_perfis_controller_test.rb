require "test_helper"

class UPerfisControllerTest < ActionDispatch::IntegrationTest
  setup do
    @u_perfil = u_perfis(:one)
  end

  test "should get index" do
    get u_perfis_url
    assert_response :success
  end

  test "should get new" do
    get new_u_perfil_url
    assert_response :success
  end

  test "should create u_perfil" do
    assert_difference("UPerfil.count") do
      post u_perfis_url, params: { u_perfil: { descricao: @u_perfil.descricao } }
    end

    assert_redirected_to u_perfil_url(UPerfil.last)
  end

  test "should show u_perfil" do
    get u_perfil_url(@u_perfil)
    assert_response :success
  end

  test "should get edit" do
    get edit_u_perfil_url(@u_perfil)
    assert_response :success
  end

  test "should update u_perfil" do
    patch u_perfil_url(@u_perfil), params: { u_perfil: { descricao: @u_perfil.descricao } }
    assert_redirected_to u_perfil_url(@u_perfil)
  end

  test "should destroy u_perfil" do
    assert_difference("UPerfil.count", -1) do
      delete u_perfil_url(@u_perfil)
    end

    assert_redirected_to u_perfis_url
  end
end
