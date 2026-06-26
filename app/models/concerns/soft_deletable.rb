module SoftDeletable
  extend ActiveSupport::Concern

  included do
    default_scope { where(deleted_at: nil) }

    scope :with_discarded, -> { unscope(where: :deleted_at) }
    scope :discarded, -> { with_discarded.where.not(deleted_at: nil) }
  end

  def discard
    update(deleted_at: Time.current)
  end

  def discarded?
    deleted_at.present?
  end
end
