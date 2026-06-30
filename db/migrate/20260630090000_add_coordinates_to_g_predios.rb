class AddCoordinatesToGPredios < ActiveRecord::Migration[8.1]
  def change
    add_column :g_predios, :latitude, :decimal, precision: 10, scale: 6
    add_column :g_predios, :longitude, :decimal, precision: 10, scale: 6
  end
end
