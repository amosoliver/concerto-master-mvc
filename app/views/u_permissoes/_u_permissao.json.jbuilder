json.extract! u_permissao, :id, :descricao, :controlador, :acao, :admin, :created_at, :updated_at
json.url u_permissao_url(u_permissao, format: :json)
