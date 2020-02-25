json.rows @users do |user|
  json.partial! 'user', user: user
end
json.extract! @users, :total_count
