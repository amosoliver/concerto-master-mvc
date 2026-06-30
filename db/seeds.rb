require Rails.root.join("db/seeds/catalog")
Seeds::Catalog.populate!
puts "Seeds concluídos. Para geodados: bin/rails db:populate_geo"
