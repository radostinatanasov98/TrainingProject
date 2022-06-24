require 'test_helper'

class PerscriptionTest < ActiveSupport::TestCase
  test 'perscription_is_not_created_with_missing_examination_id' do
    perscription = Perscription.new(description: 'test')

    assert_not perscription.save, 'Perscription is saved with missing examination id.'
  end

  test 'perscription_is__created_with_missing_description' do
    perscription = Perscription.new(examination_id: 1)

    assert perscription.save, 'Perscription is saved with missing description.'
  end

  test 'perscription_is_not_created_with_nonexistent_examination_id' do
    perscription = Perscription.new(examination_id: -1, description: 'test')

    assert_not perscription.save, 'Perscription is being saved with nonexistent examination id.'
  end

  test 'perscription_is_created_with_valid_params' do
    perscription = Perscription.new(examination_id: 1, description: 'test')

    assert perscription.save, 'Perscription is not saved with valid params.'
  end
end
