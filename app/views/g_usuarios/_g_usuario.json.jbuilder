json.extract! g_usuario, :id, :email, :encrypted_password, :ativo, :g_pessoa_id, :created_at, :updated_at
json.url g_usuario_url(g_usuario, format: :json)
