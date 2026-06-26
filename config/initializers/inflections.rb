# frozen_string_literal: true

ActiveSupport::Inflector.inflections(:en) do |inflect|

  # Gerais
  inflect.irregular 'g_pais', 'g_paises'
  inflect.irregular 'g_estado', 'g_estados'
  inflect.irregular 'g_municipio', 'g_municipios'
  inflect.irregular 'g_entidade', 'g_entidades'
  inflect.irregular 'g_predio', 'g_predios'
  inflect.irregular 'g_pessoa', 'g_pessoas'
  inflect.irregular 'g_sexo', 'g_sexos'
  inflect.irregular 'g_instrumento', 'g_instrumentos'
  inflect.irregular 'g_naipe', 'g_naipes'
  inflect.irregular 'g_instrumento_naipe', 'g_instrumentos_naipes'

  # Usuários
  inflect.irregular 'g_usuario', 'g_usuarios'

  # Segurança
  inflect.irregular 'u_perfil', 'u_perfis'
  inflect.irregular 'u_permissao', 'u_permissoes'
  inflect.irregular 'u_funcao', 'u_funcoes'
  inflect.irregular 'u_tipo_funcao', 'u_tipos_funcoes'
  inflect.irregular 'u_perfil_funcao', 'u_perfis_funcoes'
  inflect.irregular 'u_perfil_permissao', 'u_perfis_permissoes'
  inflect.irregular 'u_usuario_perfil', 'u_usuarios_perfis'

  # Música
  inflect.irregular 'm_grupo', 'm_grupos'
  inflect.irregular 'm_tipo_grupo', 'm_tipos_grupos'
  inflect.irregular 'm_grupo_pessoa', 'm_grupos_pessoas'

  inflect.irregular 'm_evento', 'm_eventos'
  inflect.irregular 'm_evento_musica', 'm_eventos_musicas'

  inflect.irregular 'm_musica', 'm_musicas'
  inflect.irregular 'm_compositor', 'm_compositores'
  inflect.irregular 'm_artista', 'm_artistas'

  inflect.irregular 'm_arranjo', 'm_arranjos'
  inflect.irregular 'm_arranjador', 'm_arranjadores'
  inflect.irregular 'm_tonalidade', 'm_tonalidades'
  inflect.irregular 'm_arranjo_instrumento_naipe', 'm_arranjos_instrumentos_naipes'

  # Pessoas
  inflect.irregular 'm_pessoa_funcao', 'm_pessoas_funcoes'

end