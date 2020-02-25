module Helpers::Authorize
  def authorize_user(role_codes = UserRole::CODES, user = context[:user])
    raise Error::NotFound, code: 'AUTH_USER_NOT_FOUND' if user.blank?
    raise Error::Forbidden, code: 'AUTH_USER_BLOCKED' if user.status_code == UserStatus::Blocked
    raise Error::Forbidden, code: 'AUTH_USER_ACCESS_FORBIDDEN' unless role_codes.include?(user.role_code)
  end
end
