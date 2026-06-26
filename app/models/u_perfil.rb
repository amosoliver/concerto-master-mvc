class UPerfil < ApplicationRecord
  include SoftDeletable

  has_many :u_perfis_funcoes
  has_many :u_funcoes, through: :u_perfis_funcoes
  has_many :u_perfis_permissoes
  has_many :u_permissoes, through: :u_perfis_permissoes
  has_many :u_usuarios_perfis
  has_many :g_usuarios, through: :u_usuarios_perfis

  def to_s
    descricao
  end

  def self.ransackable_attributes(_auth_object = nil)
    ["descricao", "deleted_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  def sync_u_permissoes!(permissao_ids)
    sync_join_records!(
      join_model: UPerfilPermissao,
      foreign_key: :u_permissao_id,
      target_ids: permissao_ids
    )
  end

  def sync_u_funcoes!(funcao_ids)
    sync_join_records!(
      join_model: UPerfilFuncao,
      foreign_key: :u_funcao_id,
      target_ids: funcao_ids
    )
  end

  private

  def sync_join_records!(join_model:, foreign_key:, target_ids:)
    target_ids = Array(target_ids).reject(&:blank?).map(&:to_i).uniq
    existing_records = join_model.with_discarded.where(u_perfil_id: id).index_by(&foreign_key)

    target_ids.each do |target_id|
      record = existing_records[target_id] || join_model.new(u_perfil_id: id, foreign_key => target_id)
      next if record.persisted? && record.deleted_at.nil?

      record.deleted_at = nil
      record.save!
    end

    existing_records.each do |target_id, record|
      next if target_ids.include?(target_id)
      next if record.deleted_at.present?

      record.update!(deleted_at: Time.current)
    end
  end
end
