require "test_helper"

class GEntidadeTest < ActiveSupport::TestCase
  test "requires descricao estado e municipio" do
    entidade = GEntidade.new

    assert_not entidade.valid?
    assert entidade.errors.added?(:descricao, :blank)
    assert entidade.errors.added?(:g_estado, :blank) || entidade.errors.added?(:g_estado, :required)
    assert entidade.errors.added?(:g_municipio, :blank) || entidade.errors.added?(:g_municipio, :required)
  end

  test "validates municipio belongs to selected estado" do
    entidade = g_entidades(:one)
    entidade.g_estado = g_estados(:two)

    assert_not entidade.valid?
    assert_includes entidade.errors[:g_municipio_id], "deve pertencer ao estado selecionado"
  end
end
