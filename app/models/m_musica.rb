class MMusica < ApplicationRecord
  include SoftDeletable
  include Uppercasable

  attr_accessor :novo_m_compositor, :novo_m_artista

  upcases :descricao

  belongs_to :g_entidade
  belongs_to :m_compositor, optional: true
  belongs_to :m_artista

  has_many :m_arranjos
  has_many :m_eventos_musicas
  has_many :m_eventos, through: :m_eventos_musicas

  before_validation :assign_g_entidade

  validates :descricao, :url_referencia, :g_entidade, :m_artista, presence: true

  def to_s
    descricao
  end

  def url_referencia_embed
    self.class.embed_url_for(url_referencia)
  end

  def url_referencia_embeddable?
    url_referencia_embed.present?
  end

  def url_referencia_provider
    self.class.provider_name_for(url_referencia)
  end

  def url_referencia_thumbnail_url
    self.class.thumbnail_url_for(url_referencia)
  end

  def self.embed_url_for(url)
    return if url.blank?

    parsed = URI.parse(url)
    host = parsed.host.to_s.sub(/\Awww\./, "")

    case host
    when "youtube.com", "m.youtube.com"
      video_id = CGI.parse(parsed.query.to_s)["v"]&.first
      video_id.present? ? "https://www.youtube.com/embed/#{video_id}" : nil
    when "youtu.be"
      video_id = parsed.path.to_s.split("/").reject(&:blank?).first
      video_id.present? ? "https://www.youtube.com/embed/#{video_id}" : nil
    when "vimeo.com"
      video_id = parsed.path.to_s.split("/").reject(&:blank?).first
      video_id.present? ? "https://player.vimeo.com/video/#{video_id}" : nil
    end
  rescue URI::InvalidURIError
    nil
  end

  def self.provider_name_for(url)
    return if url.blank?

    parsed = URI.parse(url)
    host = parsed.host.to_s.sub(/\Awww\./, "")

    case host
    when "youtube.com", "m.youtube.com", "youtu.be"
      "YouTube"
    when "vimeo.com"
      "Vimeo"
    else
      host.presence
    end
  rescue URI::InvalidURIError
    nil
  end

  def self.thumbnail_url_for(url)
    return if url.blank?

    parsed = URI.parse(url)
    host = parsed.host.to_s.sub(/\Awww\./, "")

    case host
    when "youtube.com", "m.youtube.com"
      video_id = CGI.parse(parsed.query.to_s)["v"]&.first
      video_id.present? ? "https://img.youtube.com/vi/#{video_id}/hqdefault.jpg" : nil
    when "youtu.be"
      video_id = parsed.path.to_s.split("/").reject(&:blank?).first
      video_id.present? ? "https://img.youtube.com/vi/#{video_id}/hqdefault.jpg" : nil
    end
  rescue URI::InvalidURIError
    nil
  end

  def self.ransackable_attributes(_auth_object = nil)
    ["descricao", "g_entidade_id", "m_compositor_id", "m_artista_id", "url_referencia", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  private

  def assign_g_entidade
    self.g_entidade_id ||= Current.g_entidade&.id || Current.g_usuario&.g_pessoa&.g_entidade_id
  end
end
