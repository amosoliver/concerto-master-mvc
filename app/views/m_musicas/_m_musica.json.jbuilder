json.extract! m_musica, :id, :descricao, :m_compositor_id, :m_artista_id, :created_at, :updated_at
json.url m_musica_url(m_musica, format: :json)
