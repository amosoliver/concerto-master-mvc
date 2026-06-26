class AddGEntidadeIdToGEntidades < ActiveRecord::Migration[8.1]
  def change
    add_reference :g_entidades, :g_entidade, foreign_key: true
  end
end
