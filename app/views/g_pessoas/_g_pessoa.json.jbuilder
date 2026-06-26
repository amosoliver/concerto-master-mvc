json.extract! g_pessoa, :id, :nome, :email, :g_entidade_id, :g_sexo_id, :created_at, :updated_at
json.url g_pessoa_url(g_pessoa, format: :json)
