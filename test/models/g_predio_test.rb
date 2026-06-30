require "test_helper"

class GPredioTest < ActiveSupport::TestCase
  test "requires address fields and coordinates" do
    predio = GPredio.new(g_entidade: g_entidades(:one))

    assert_not predio.valid?
    assert predio.errors.added?(:nome_fantasia, :blank)
    assert predio.errors.added?(:cep, :blank)
    assert predio.errors.added?(:logradouro, :blank)
    assert predio.errors.added?(:bairro, :blank)
    assert predio.errors.added?(:latitude, :blank)
    assert predio.errors.added?(:longitude, :blank)
  end

  test "normalizes cep before validation" do
    predio = g_predios(:one)
    predio.cep = "76.800-000"

    predio.valid?

    assert_equal "76800000", predio.cep
  end
end
