class ExistingUserValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add :base, 'No users exists with provided id.' unless User.exists?(record.user_id)
  end
end

class Examination < ApplicationRecord
  validates :user_id, :weight_kg, :height_cm, :anamnesis, presence: true
  validates_with ExistingUserValidator, field: :user_id

  belongs_to :user, foreign_key: 'user_id'
  has_one :perscription
end
