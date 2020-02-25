module Session
  def self.user
    RequestLocals.fetch(:session_user) { nil }
  end

  def self.user=(user)
    RequestLocals.store[:session_user] = user
  end

  def self.type
    RequestLocals.fetch(:session_type) { nil }
  end

  def self.type=(type)
    RequestLocals.store[:session_type] = type
  end

  def self.token
    RequestLocals.fetch(:session_token) { nil }
  end

  def self.token=(token)
    RequestLocals.store[:session_token] = token
  end

  def self.user_active?
    user.present? && user.status_code != UserStatus::Blocked
  end
end
