require 'digest'

class User < ApplicationRecord
  include Archivable
  PASSWORD_CHANGE_TIMEOUT = 5.minutes

  AUTH_ATTEMPTS_LIMIT = 99
  AUTH_BLOCK_INTERVAL = 15.minutes

  CSV_FIELDS_MAPPING = {
    'Login' => {
      column: :login,
      map: ->(login) { login },
      primary: true
    },
    'eMail' => {
      column: :email,
      map: ->(email) { email.strip.downcase }
    },
    'First name' => {
      column: :first_name,
      map: ->(first_name) { first_name&.strip }
    },
    'Last name' => {
      column: :last_name,
      map: ->(last_name) { last_name&.strip }
    },
    'Role' => {
      column: :role_code,
      map: lambda { |role_title|
        roles = {
          'Admin': UserRole::Admin,
          'Chief': UserRole::Chief,
          'Scout': UserRole::Scout
        }
        roles[role_title.to_sym]
      }
    }
  }.freeze
  CSV_FIELDS_REFS_CREATORS = {}.freeze

  has_secure_password

  has_one_attached :photo

  enum status_code: UserStatus::CODES_MAP
  enum role_code: UserRole::CODES_MAP

  belongs_to :entity_type, optional: true

  has_many :user_tokens, dependent: :destroy
  has_many :auth_tokens, class_name: :UserToken

  has_many :user_action_tokens, dependent: :destroy
  has_many :action_tokens, class_name: :UserActionToken

  before_validation :ensure_password, on: :create
  before_validation :ensure_status_code, on: :create

  before_save :downcase_login_and_email
  before_save :touch_password_updated_at, if: :will_save_change_to_password_digest?

  after_create :notify_new_account

  validates :login, presence: true, length: { in: 2..48 }, format: { with: /\A[a-z]+[a-z0-9_\-\.]+\z/i }, uniqueness: true
  validates :email, allow_blank: true, length: { in: 6..48 }, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :phone, allow_blank: true, phone: true, uniqueness: true

  validates :password, length: { minimum: 6 }, allow_blank: true
  validate :password_constraints

  validates :first_name, :last_name, length: { maximum: 48 }

  validates :status_code, presence: true
  validates :role_code, presence: true

  scope :accessible, lambda { |user = Session.user|
    if [UserRole::Admin].include? user.role_code
    else
      where(id: user.id)
    end
  }

  scope :with_token, lambda { |token|
    joins(:user_tokens).where(user_tokens: { token: token }).where.not(users: { status_code: UserStatus::Blocked }).order(nil).select('users.*')
  }

  scope :by_role_codes, lambda { |role_codes|
    where(role_code: role_codes)
  }

  def fcm_topic_name
    salt = Rails.application.secrets.fcm_topic_salt
    Digest::SHA256.hexdigest("#{id}_#{salt}")
  end

  def new_password!
    set_random_password
    save!
    notify_new_password
  end

  def notify_new_account
    params = {
      login: login,
      first_name: first_name,
      last_name: last_name,
      password: password
    }
    send_email('users/new_account', 'Регистрация', params)
  end

  def notify_new_password
    params = {
      login: login,
      first_name: first_name,
      last_name: last_name,
      password: password
    }
    send_email('users/new_password', 'Новый пароль', params)
  end

  def notify_password_changed
    params = {
      first_name: first_name,
      last_name: last_name,
      login: login
    }
    send_email('users/password_changed', 'Пароль изменён', params)
  end

  def send_email(template, subject, view_params = {})
    params = {
      sender: 'audit@in.trinitydigital.ru',
      subject: "Audit: #{subject}",
      recipients: [email],
      view: view_params
    }
    MailWorker.perform_async(template, params)
  end

  def check_auth_attempt!(request)
    self.auth_attempts += 1
    if auth_attempts >= AUTH_ATTEMPTS_LIMIT
      self.auth_blocked_until = Time.current + AUTH_BLOCK_INTERVAL
      self.auth_attempts = 0
      LogHelper.info("User `#{login}` failed auth #{AUTH_ATTEMPTS_LIMIT} times from IP `#{request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip}` and agent `#{request.headers['HTTP_USER_AGENT']}`")
    end
    save(validate: false)
  end

  def password_change_allowed?
    password_updated_at.present? && password_updated_at.since(PASSWORD_CHANGE_TIMEOUT).future?
  end

  private

  def set_random_password
    self.password = [Forgery::Basic.color[0, 4], Forgery::Address.street_name.gsub(/[\s]+/, '')[0, 4], rand(10_000)].join
  end

  def ensure_password
    set_random_password if password_digest.blank?
  end

  def ensure_status_code
    self.status_code = UserStatus::Active if status_code.blank?
  end

  def downcase_login_and_email
    login.downcase! if login.present?
    email.downcase! if email.present?
  end

  def touch_password_updated_at
    self.password_updated_at = Time.current
  end

  def password_constraints
    if password.present?
      errors.add(:password, 'must contain at least one lowercase letter') unless /[a-z]/.match?(password)
      errors.add(:password, 'must contain at least one uppercase letter') unless /[A-Z]/.match?(password)
      errors.add(:password, 'must contain at least one number') unless /[0-9]/.match?(password)
    end
  end
end
