class UserToken < ApplicationRecord
  belongs_to :user
  self.primary_key = 'token'

  before_create :generate_token

  def generate_token
    self.token = SecureRandom.hex(64)
  end
end
