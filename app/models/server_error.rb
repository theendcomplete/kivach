class ServerError < ApplicationRecord
  after_create :notify

  def notify
    LogHelper.error self
  end
end
