[
  {
    login: 'amtd',
    email: 'am@trinitydigital.ru'
  },
  {
    login: 'vbtd',
    email: 'vb@trinitydigital.ru'
  }
].each do |user|
  User.where(login: user[:login]).first_or_create!(email: user[:email], role_code: UserRole::Admin)
end
