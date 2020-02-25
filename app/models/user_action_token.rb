class UserActionToken < ApplicationRecord
  EXPIRES_IN = 1.hour

  belongs_to :user

  before_validation :ensure_token
  before_create :ensure_expiration

  after_create :notify_user

  validates :type_code, presence: true
  enum type_code: UserActionType::CODES_MAP

  def expired?
    expires_at < Time.current
  end

  private

  def ensure_token
    self.token = SecureRandom.hex(64) if token.blank?
  end

  def ensure_expiration
    self.expires_at = Time.current + EXPIRES_IN
  end

  def notify_user
    case type_code.to_sym
    when :new_password
      params = {
        password_change_url: File.join(Rails.configuration.app['admin_web_url'], 'actions', token),
        user: {
          first_name: user.first_name,
          last_name: user.last_name,
          login: user.login
        }
      }
      user.send_email('user_actions/new_password', 'Изменение пароля', params)
    end
  end
end
