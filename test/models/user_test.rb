require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should create or select user' do
    params = {
      login: 'admin_test',
      email: 'admin@localhost',
      role_code: 'admin',
      status_code: 'active',
      first_name: 'Admin',
      last_name: 'Test'
    }
    user = User.where(login: 'admin_test').first_or_create(params)
    assert user.present?
  end
end
