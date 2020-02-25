module Archivable
  extend ActiveSupport::Concern

  included do
    scope :active, -> { where(archived_at: nil) }
    scope :archived, -> { where.not(archived_at: nil) }
  end

  def destroy(params = {})
    if params[:permanent]
      super()
    else
      touch :archived_at
    end
  end

  def revive
    update_attribute :archived_at, nil
  end
end
