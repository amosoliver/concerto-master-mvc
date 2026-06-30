class PopulateCatalogData < ActiveRecord::Migration[8.0]
  def up
    require Rails.root.join("db/seeds/catalog")
    Seeds::Catalog.populate!
  end

  def down
    # catálogo removido manualmente se necessário
  end
end
