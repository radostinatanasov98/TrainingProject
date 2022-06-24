require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'user_is_not_created_without_params' do
    user = User.new
    assert_not user.save, 'User is created without params.'
  end

  test 'user_is_not_created_without_first_name' do
    user = User.new(email: 'test@test.com', password: '123456', last_name: 'test',
                    address: 'test', date_of_birth: Time.current.utc, role_id: 2)
    assert_not user.save, 'User is created without first name.'
  end

  test 'user_is_not_created_without_last_name' do
    user = User.new(email: 'test@test.com', password: '123456', first_name: 'test',
                    address: 'test', date_of_birth: Time.current.utc, role_id: 2)
    assert_not user.save, 'User is created without last name.'
  end

  test 'user_is_not_created_without_address' do
    user = User.new(email: 'test@test.com', password: '123456', first_name: 'test',
                    date_of_birth: Time.current.utc, role_id: 2)
    assert_not user.save, 'User is created without last name.'
  end

  test 'user_is_not_created_without_date_of_birth' do
    user = User.new(email: 'test@test.com', password: '123456', first_name: 'test',
                    last_name: 'test', address: 'test', role_id: 2)
    assert_not user.save, 'User is created without last name.'
  end

  test 'user_is_created_with_valid_params' do
    date_of_birth = Time.current.utc

    new_user = User.new(email: 'test@test.com', password: '123456', first_name: 'test',
                        last_name: 'test', address: 'test', date_of_birth:, role_id: 3)

    assert new_user.save, 'User is not created with valid params.'
  end

  test 'user_is_created_with_role_id_value_2_if_not_specified' do
    user = User.new(email: 'test@test.com', password: '123456', first_name: 'test',
                    last_name: 'test', address: 'test', date_of_birth: Time.current.utc)
    assert user.save, 'User is not created with valid params.'
    assert User.find_by(email: 'test@test.com').role_id == 2, 'User is created with wrong role id.'
  end

  test 'user_is_not_created_with_duplicate_email' do
    first_user = User.new(email: 'test@test.com', password: '123456', first_name: 'test',
                          last_name: 'one', address: 'test1', date_of_birth: Time.current.utc)

    second_user = User.new(email: 'test@test.com', password: '123456', first_name: 'test',
                           last_name: 'two', address: 'test2', date_of_birth: Time.current.utc)

    assert first_user.save, 'User is not created with valid params'
    assert_not second_user.save, 'User is created with duplicate email.'
  end
end
