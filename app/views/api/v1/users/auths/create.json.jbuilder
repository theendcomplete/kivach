if Session.present? && Session.user.present? && Session.token.present?
  json.token Session.token
  json.extract! Session.user, :role_code
end
