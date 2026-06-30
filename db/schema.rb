# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_06_30_133000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "g_entidades", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "descricao"
    t.bigint "g_entidade_id"
    t.bigint "g_estado_id", null: false
    t.bigint "g_municipio_id", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_g_entidades_on_deleted_at"
    t.index ["g_entidade_id"], name: "index_g_entidades_on_g_entidade_id"
    t.index ["g_estado_id"], name: "index_g_entidades_on_g_estado_id"
    t.index ["g_municipio_id"], name: "index_g_entidades_on_g_municipio_id"
  end

  create_table "g_estados", force: :cascade do |t|
    t.string "codigo_ibge"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "descricao"
    t.bigint "g_pais_id", null: false
    t.string "sigla"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_g_estados_on_deleted_at"
    t.index ["g_pais_id"], name: "index_g_estados_on_g_pais_id"
  end

  create_table "g_instrumentos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "descricao"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_g_instrumentos_on_deleted_at"
  end

  create_table "g_instrumentos_naipes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.bigint "g_instrumento_id", null: false
    t.bigint "g_naipe_id", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_g_instrumentos_naipes_on_deleted_at"
    t.index ["g_instrumento_id"], name: "index_g_instrumentos_naipes_on_g_instrumento_id"
    t.index ["g_naipe_id"], name: "index_g_instrumentos_naipes_on_g_naipe_id"
  end

  create_table "g_municipios", force: :cascade do |t|
    t.string "codigo_ibge"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "descricao"
    t.bigint "g_estado_id", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_g_municipios_on_deleted_at"
    t.index ["g_estado_id"], name: "index_g_municipios_on_g_estado_id"
  end

  create_table "g_naipes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "descricao"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_g_naipes_on_deleted_at"
  end

  create_table "g_paises", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "descricao"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_g_paises_on_deleted_at"
  end

  create_table "g_pessoas", force: :cascade do |t|
    t.string "cpf"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "email"
    t.bigint "g_entidade_id", null: false
    t.bigint "g_sexo_id", null: false
    t.string "nome"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_g_pessoas_on_deleted_at"
    t.index ["g_entidade_id"], name: "index_g_pessoas_on_g_entidade_id"
    t.index ["g_sexo_id"], name: "index_g_pessoas_on_g_sexo_id"
  end

  create_table "g_pessoas_instrumentos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.bigint "g_entidade_id", null: false
    t.bigint "g_instrumento_naipe_id", null: false
    t.bigint "g_pessoa_id", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_g_pessoas_instrumentos_on_deleted_at"
    t.index ["g_entidade_id"], name: "index_g_pessoas_instrumentos_on_g_entidade_id"
    t.index ["g_instrumento_naipe_id"], name: "index_g_pessoas_instrumentos_on_g_instrumento_naipe_id"
    t.index ["g_pessoa_id"], name: "index_g_pessoas_instrumentos_on_g_pessoa_id"
  end

  create_table "g_predios", force: :cascade do |t|
    t.string "bairro"
    t.string "cep"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.bigint "g_entidade_id", null: false
    t.decimal "latitude", precision: 10, scale: 6
    t.string "logradouro"
    t.decimal "longitude", precision: 10, scale: 6
    t.string "nome_fantasia"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_g_predios_on_deleted_at"
    t.index ["g_entidade_id"], name: "index_g_predios_on_g_entidade_id"
  end

  create_table "g_sexos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "descricao"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_g_sexos_on_deleted_at"
  end

  create_table "g_usuarios", force: :cascade do |t|
    t.boolean "ativo"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "email"
    t.string "encrypted_password"
    t.bigint "g_pessoa_id", null: false
    t.boolean "primeiro_acesso", default: true, null: false
    t.datetime "remember_created_at"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_g_usuarios_on_deleted_at"
    t.index ["g_pessoa_id"], name: "index_g_usuarios_on_g_pessoa_id"
  end

  create_table "m_arranjadores", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "descricao"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_m_arranjadores_on_deleted_at"
  end

  create_table "m_arranjos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "descricao"
    t.bigint "g_entidade_id", null: false
    t.bigint "m_arranjador_id", null: false
    t.bigint "m_musica_id", null: false
    t.bigint "m_tipo_arranjo_id"
    t.bigint "m_tonalidade_id", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_m_arranjos_on_deleted_at"
    t.index ["g_entidade_id"], name: "index_m_arranjos_on_g_entidade_id"
    t.index ["m_arranjador_id"], name: "index_m_arranjos_on_m_arranjador_id"
    t.index ["m_musica_id"], name: "index_m_arranjos_on_m_musica_id"
    t.index ["m_tipo_arranjo_id"], name: "index_m_arranjos_on_m_tipo_arranjo_id"
    t.index ["m_tonalidade_id"], name: "index_m_arranjos_on_m_tonalidade_id"
  end

  create_table "m_arranjos_instrumentos_naipes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.bigint "g_entidade_id", null: false
    t.bigint "g_instrumento_naipe_id", null: false
    t.bigint "m_arranjo_id", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_m_arranjos_instrumentos_naipes_on_deleted_at"
    t.index ["g_entidade_id"], name: "index_m_arranjos_instrumentos_naipes_on_g_entidade_id"
    t.index ["g_instrumento_naipe_id"], name: "index_m_arranjos_instrumentos_naipes_on_g_instrumento_naipe_id"
    t.index ["m_arranjo_id"], name: "index_m_arranjos_instrumentos_naipes_on_m_arranjo_id"
  end

  create_table "m_artistas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "descricao"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_m_artistas_on_deleted_at"
  end

  create_table "m_compositores", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "descricao"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_m_compositores_on_deleted_at"
  end

  create_table "m_ensaio_eventos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.bigint "g_entidade_id", null: false
    t.bigint "m_ensaio_id", null: false
    t.bigint "m_evento_id", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_m_ensaio_eventos_on_deleted_at"
    t.index ["g_entidade_id"], name: "index_m_ensaio_eventos_on_g_entidade_id"
    t.index ["m_ensaio_id", "m_evento_id"], name: "index_m_ensaio_eventos_on_ensaio_and_evento", unique: true
    t.index ["m_ensaio_id"], name: "index_m_ensaio_eventos_on_m_ensaio_id"
    t.index ["m_evento_id"], name: "index_m_ensaio_eventos_on_m_evento_id"
  end

  create_table "m_ensaio_grupos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.bigint "g_entidade_id", null: false
    t.bigint "m_ensaio_id", null: false
    t.bigint "m_grupo_id", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_m_ensaio_grupos_on_deleted_at"
    t.index ["g_entidade_id"], name: "index_m_ensaio_grupos_on_g_entidade_id"
    t.index ["m_ensaio_id", "m_grupo_id"], name: "index_m_ensaio_grupos_on_ensaio_and_grupo", unique: true
    t.index ["m_ensaio_id"], name: "index_m_ensaio_grupos_on_m_ensaio_id"
    t.index ["m_grupo_id"], name: "index_m_ensaio_grupos_on_m_grupo_id"
  end

  create_table "m_ensaio_musicas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.bigint "g_entidade_id", null: false
    t.bigint "m_ensaio_id", null: false
    t.bigint "m_evento_musica_id", null: false
    t.string "observacao"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_m_ensaio_musicas_on_deleted_at"
    t.index ["g_entidade_id"], name: "index_m_ensaio_musicas_on_g_entidade_id"
    t.index ["m_ensaio_id"], name: "index_m_ensaio_musicas_on_m_ensaio_id"
    t.index ["m_evento_musica_id"], name: "index_m_ensaio_musicas_on_m_evento_musica_id"
  end

  create_table "m_ensaios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "data_fim"
    t.datetime "data_inicio"
    t.datetime "deleted_at"
    t.string "descricao"
    t.bigint "g_entidade_id", null: false
    t.bigint "g_predio_id", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_m_ensaios_on_deleted_at"
    t.index ["g_entidade_id"], name: "index_m_ensaios_on_g_entidade_id"
    t.index ["g_predio_id"], name: "index_m_ensaios_on_g_predio_id"
  end

  create_table "m_evento_musica_grupos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.bigint "g_entidade_id", null: false
    t.bigint "m_evento_musica_id", null: false
    t.bigint "m_grupo_id", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_m_evento_musica_grupos_on_deleted_at"
    t.index ["g_entidade_id"], name: "index_m_evento_musica_grupos_on_g_entidade_id"
    t.index ["m_evento_musica_id", "m_grupo_id"], name: "index_m_evento_musica_grupos_on_item_and_grupo", unique: true
    t.index ["m_evento_musica_id"], name: "index_m_evento_musica_grupos_on_m_evento_musica_id"
    t.index ["m_grupo_id"], name: "index_m_evento_musica_grupos_on_m_grupo_id"
  end

  create_table "m_eventos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "data_fim"
    t.datetime "data_inicio"
    t.datetime "deleted_at"
    t.string "descricao"
    t.bigint "g_entidade_id", null: false
    t.bigint "g_predio_id", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_m_eventos_on_deleted_at"
    t.index ["g_entidade_id"], name: "index_m_eventos_on_g_entidade_id"
    t.index ["g_predio_id"], name: "index_m_eventos_on_g_predio_id"
  end

  create_table "m_eventos_musicas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.bigint "g_entidade_id", null: false
    t.bigint "m_arranjo_id"
    t.bigint "m_evento_id", null: false
    t.bigint "m_musica_id", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_m_eventos_musicas_on_deleted_at"
    t.index ["g_entidade_id"], name: "index_m_eventos_musicas_on_g_entidade_id"
    t.index ["m_arranjo_id"], name: "index_m_eventos_musicas_on_m_arranjo_id"
    t.index ["m_evento_id"], name: "index_m_eventos_musicas_on_m_evento_id"
    t.index ["m_musica_id"], name: "index_m_eventos_musicas_on_m_musica_id"
  end

  create_table "m_grupos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "descricao"
    t.bigint "g_entidade_id", null: false
    t.bigint "m_tipo_grupo_id", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_m_grupos_on_deleted_at"
    t.index ["g_entidade_id"], name: "index_m_grupos_on_g_entidade_id"
    t.index ["m_tipo_grupo_id"], name: "index_m_grupos_on_m_tipo_grupo_id"
  end

  create_table "m_grupos_instrumentos_naipes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.bigint "g_entidade_id", null: false
    t.bigint "g_instrumento_naipe_id", null: false
    t.bigint "m_grupo_id", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_m_grupos_instrumentos_naipes_on_deleted_at"
    t.index ["g_entidade_id"], name: "index_m_grupos_instrumentos_naipes_on_g_entidade_id"
    t.index ["g_instrumento_naipe_id"], name: "index_m_grupos_instrumentos_naipes_on_g_instrumento_naipe_id"
    t.index ["m_grupo_id"], name: "index_m_grupos_instrumentos_naipes_on_m_grupo_id"
  end

  create_table "m_grupos_pessoas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.bigint "g_entidade_id", null: false
    t.bigint "g_pessoa_id", null: false
    t.bigint "m_grupo_id", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_m_grupos_pessoas_on_deleted_at"
    t.index ["g_entidade_id"], name: "index_m_grupos_pessoas_on_g_entidade_id"
    t.index ["g_pessoa_id"], name: "index_m_grupos_pessoas_on_g_pessoa_id"
    t.index ["m_grupo_id"], name: "index_m_grupos_pessoas_on_m_grupo_id"
  end

  create_table "m_musicas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "descricao"
    t.bigint "g_entidade_id", null: false
    t.bigint "m_artista_id", null: false
    t.bigint "m_compositor_id"
    t.datetime "updated_at", null: false
    t.string "url_referencia"
    t.index ["deleted_at"], name: "index_m_musicas_on_deleted_at"
    t.index ["g_entidade_id"], name: "index_m_musicas_on_g_entidade_id"
    t.index ["m_artista_id"], name: "index_m_musicas_on_m_artista_id"
    t.index ["m_compositor_id"], name: "index_m_musicas_on_m_compositor_id"
  end

  create_table "m_pessoas_funcoes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.bigint "g_entidade_id", null: false
    t.bigint "g_pessoa_id", null: false
    t.boolean "principal"
    t.bigint "u_funcao_id", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_m_pessoas_funcoes_on_deleted_at"
    t.index ["g_entidade_id"], name: "index_m_pessoas_funcoes_on_g_entidade_id"
    t.index ["g_pessoa_id"], name: "index_m_pessoas_funcoes_on_g_pessoa_id"
    t.index ["u_funcao_id"], name: "index_m_pessoas_funcoes_on_u_funcao_id"
  end

  create_table "m_tipos_arranjos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "descricao", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_m_tipos_arranjos_on_deleted_at"
  end

  create_table "m_tipos_grupos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "descricao"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_m_tipos_grupos_on_deleted_at"
  end

  create_table "m_tonalidades", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "descricao"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_m_tonalidades_on_deleted_at"
  end

  create_table "u_funcoes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "descricao"
    t.bigint "u_tipo_funcao_id", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_u_funcoes_on_deleted_at"
    t.index ["u_tipo_funcao_id"], name: "index_u_funcoes_on_u_tipo_funcao_id"
  end

  create_table "u_perfis", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "descricao"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_u_perfis_on_deleted_at"
  end

  create_table "u_perfis_funcoes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.bigint "u_funcao_id", null: false
    t.bigint "u_perfil_id", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_u_perfis_funcoes_on_deleted_at"
    t.index ["u_funcao_id"], name: "index_u_perfis_funcoes_on_u_funcao_id"
    t.index ["u_perfil_id"], name: "index_u_perfis_funcoes_on_u_perfil_id"
  end

  create_table "u_perfis_permissoes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.bigint "u_perfil_id", null: false
    t.bigint "u_permissao_id", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_u_perfis_permissoes_on_deleted_at"
    t.index ["u_perfil_id"], name: "index_u_perfis_permissoes_on_u_perfil_id"
    t.index ["u_permissao_id"], name: "index_u_perfis_permissoes_on_u_permissao_id"
  end

  create_table "u_permissoes", force: :cascade do |t|
    t.string "acao"
    t.boolean "admin"
    t.string "controlador"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "descricao"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_u_permissoes_on_deleted_at"
  end

  create_table "u_tipos_funcoes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "descricao"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_u_tipos_funcoes_on_deleted_at"
  end

  create_table "u_usuarios_perfis", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.bigint "g_usuario_id", null: false
    t.bigint "u_perfil_id", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_u_usuarios_perfis_on_deleted_at"
    t.index ["g_usuario_id"], name: "index_u_usuarios_perfis_on_g_usuario_id"
    t.index ["u_perfil_id"], name: "index_u_usuarios_perfis_on_u_perfil_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "g_entidades", "g_entidades"
  add_foreign_key "g_entidades", "g_estados"
  add_foreign_key "g_entidades", "g_municipios"
  add_foreign_key "g_estados", "g_paises"
  add_foreign_key "g_instrumentos_naipes", "g_instrumentos"
  add_foreign_key "g_instrumentos_naipes", "g_naipes"
  add_foreign_key "g_municipios", "g_estados"
  add_foreign_key "g_pessoas", "g_entidades"
  add_foreign_key "g_pessoas", "g_sexos"
  add_foreign_key "g_pessoas_instrumentos", "g_entidades"
  add_foreign_key "g_pessoas_instrumentos", "g_instrumentos_naipes"
  add_foreign_key "g_pessoas_instrumentos", "g_pessoas"
  add_foreign_key "g_predios", "g_entidades"
  add_foreign_key "g_usuarios", "g_pessoas"
  add_foreign_key "m_arranjos", "g_entidades"
  add_foreign_key "m_arranjos", "m_arranjadores"
  add_foreign_key "m_arranjos", "m_musicas"
  add_foreign_key "m_arranjos", "m_tipos_arranjos"
  add_foreign_key "m_arranjos", "m_tonalidades"
  add_foreign_key "m_arranjos_instrumentos_naipes", "g_entidades"
  add_foreign_key "m_arranjos_instrumentos_naipes", "g_instrumentos_naipes"
  add_foreign_key "m_arranjos_instrumentos_naipes", "m_arranjos"
  add_foreign_key "m_ensaio_eventos", "g_entidades"
  add_foreign_key "m_ensaio_eventos", "m_ensaios"
  add_foreign_key "m_ensaio_eventos", "m_eventos"
  add_foreign_key "m_ensaio_grupos", "g_entidades"
  add_foreign_key "m_ensaio_grupos", "m_ensaios"
  add_foreign_key "m_ensaio_grupos", "m_grupos"
  add_foreign_key "m_ensaio_musicas", "g_entidades"
  add_foreign_key "m_ensaio_musicas", "m_ensaios"
  add_foreign_key "m_ensaio_musicas", "m_eventos_musicas"
  add_foreign_key "m_ensaios", "g_entidades"
  add_foreign_key "m_ensaios", "g_predios"
  add_foreign_key "m_evento_musica_grupos", "g_entidades"
  add_foreign_key "m_evento_musica_grupos", "m_eventos_musicas"
  add_foreign_key "m_evento_musica_grupos", "m_grupos"
  add_foreign_key "m_eventos", "g_entidades"
  add_foreign_key "m_eventos", "g_predios"
  add_foreign_key "m_eventos_musicas", "g_entidades"
  add_foreign_key "m_eventos_musicas", "m_arranjos"
  add_foreign_key "m_eventos_musicas", "m_eventos"
  add_foreign_key "m_eventos_musicas", "m_musicas"
  add_foreign_key "m_grupos", "g_entidades"
  add_foreign_key "m_grupos", "m_tipos_grupos"
  add_foreign_key "m_grupos_instrumentos_naipes", "g_entidades"
  add_foreign_key "m_grupos_instrumentos_naipes", "g_instrumentos_naipes"
  add_foreign_key "m_grupos_instrumentos_naipes", "m_grupos"
  add_foreign_key "m_grupos_pessoas", "g_entidades"
  add_foreign_key "m_grupos_pessoas", "g_pessoas"
  add_foreign_key "m_grupos_pessoas", "m_grupos"
  add_foreign_key "m_musicas", "g_entidades"
  add_foreign_key "m_musicas", "m_artistas"
  add_foreign_key "m_musicas", "m_compositores"
  add_foreign_key "m_pessoas_funcoes", "g_entidades"
  add_foreign_key "m_pessoas_funcoes", "g_pessoas"
  add_foreign_key "m_pessoas_funcoes", "u_funcoes"
  add_foreign_key "u_funcoes", "u_tipos_funcoes"
  add_foreign_key "u_perfis_funcoes", "u_funcoes"
  add_foreign_key "u_perfis_funcoes", "u_perfis"
  add_foreign_key "u_perfis_permissoes", "u_perfis"
  add_foreign_key "u_perfis_permissoes", "u_permissoes"
  add_foreign_key "u_usuarios_perfis", "g_usuarios"
  add_foreign_key "u_usuarios_perfis", "u_perfis"
end
