require "test_helper"

class GPessoasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @g_pessoa = g_pessoas(:one)
    @authorized_user = build_authorized_user_for_g_pessoas!
  end

  test "advances to the next wizard step on the first valid submit" do
    sign_in @authorized_user

    post g_pessoas_url, params: {
      step: "dados",
      g_pessoa: {
        nome: "Pessoa Teste",
        email: "pessoa.teste@example.com",
        cpf: "123.456.789-00",
        g_entidade_id: @authorized_user.g_pessoa.g_entidade_id,
        g_sexo_id: g_sexos(:one).id
      }
    }

    assert_redirected_to new_g_pessoa_path(step: "grupos", resume: 1)
  end

  test "should get index" do
    get g_pessoas_url
    assert_response :success
  end

  test "should get new" do
    get new_g_pessoa_url
    assert_response :success
  end

  test "should create g_pessoa" do
    assert_difference("GPessoa.count") do
      post g_pessoas_url, params: { g_pessoa: { email: @g_pessoa.email, g_entidade_id: @g_pessoa.g_entidade_id, g_sexo_id: @g_pessoa.g_sexo_id, nome: @g_pessoa.nome } }
    end

    assert_redirected_to g_pessoa_url(GPessoa.last)
  end

  test "should show g_pessoa" do
    get g_pessoa_url(@g_pessoa)
    assert_response :success
  end

  test "should get edit" do
    get edit_g_pessoa_url(@g_pessoa)
    assert_response :success
  end

  test "should update g_pessoa" do
    patch g_pessoa_url(@g_pessoa), params: { g_pessoa: { email: @g_pessoa.email, g_entidade_id: @g_pessoa.g_entidade_id, g_sexo_id: @g_pessoa.g_sexo_id, nome: @g_pessoa.nome } }
    assert_redirected_to g_pessoa_url(@g_pessoa)
  end

  test "should destroy g_pessoa" do
    assert_difference("GPessoa.count", -1) do
      delete g_pessoa_url(@g_pessoa)
    end

    assert_redirected_to g_pessoas_url
  end

  private

  def build_authorized_user_for_g_pessoas!
    pessoa = GPessoa.create!(
      nome: "Pessoa Operadora",
      email: "operadora.gpessoas@example.com",
      cpf: "98765432100",
      g_entidade: g_entidades(:one),
      g_sexo: g_sexos(:one)
    )

    usuario = GUsuario.create!(
      email: "operadora.gpessoas@example.com",
      password: "123456",
      password_confirmation: "123456",
      ativo: true,
      primeiro_acesso: false,
      g_pessoa: pessoa
    )

    perfil = UPerfil.create!(descricao: "Perfil GPessoas Test")
    %w[new create].each do |action|
      permissao = UPermissao.create!(
        descricao: "Permissao #{action} GPessoas Test",
        controlador: "g_pessoas",
        acao: action,
        admin: false
      )
      UPerfilPermissao.create!(u_perfil: perfil, u_permissao: permissao)
    end
    UUsuarioPerfil.create!(u_perfil: perfil, g_usuario: usuario)

    usuario
  end
end
