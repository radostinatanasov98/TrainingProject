require 'test_helper'

class PerscriptionDrugTest < ActiveSupport::TestCase
  test 'perscription_drug_is_not_created_with_missing_perscription_id' do
    pd = PerscriptionDrug.new(drug_id: 1, usage_description: 'test')

    assert_not pd.save, 'Perscription drug is being saved with missing perscription id.'
  end

  test 'perscription_drug_is_not_created_with_missing_drug_id' do
    pd = PerscriptionDrug.new(perscription_id: 1, usage_description: 'test')

    assert_not pd.save, 'Perscription drug is being saved with missing drug id.'
  end

  test 'perscription_drug_is_not_created_with_missing_usage_description' do
    pd = PerscriptionDrug.new(perscription_id: 1, drug_id: 1)

    assert_not pd.save, 'Perscription drug is being saved with missing usage description.'
  end

  test 'perscription_drug_is_not_created_with_nonexistent_perscription_id' do
    pd = PerscriptionDrug.new(perscription_id: -1, drug_id: 1, usage_description: 'test')

    assert_not pd.save, 'Perscription drug is being saved with nonexistent perscription id.'
  end

  test 'perscription_drug_is_not_created_with_nonexistent_drug_id' do
    pd = PerscriptionDrug.new(perscription_id: 1, drug_id: -1, usage_description: 'test')

    assert_not pd.save, 'Perscription drug is being saved with nonexistent drug id.'
  end

  test 'perscription_drug_is_created_with_valid_params' do
    pd = PerscriptionDrug.new(perscription_id: 1, drug_id: 1, usage_description: 'test')

    assert pd.save, 'Perscription drug is not being saved with valid params.'
  end
end
