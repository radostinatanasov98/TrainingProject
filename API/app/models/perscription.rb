class ExistingExaminationValidator < ActiveModel::Validator
    def validate(record)
        unless Examination.exists?(record.examination_id)
            record.errors.add :base, 'No examination exists with provided id.'
        end
    end
end

class Perscription < ApplicationRecord
    validates :examination_id, :description, presence: true
    validates_with ExistingExaminationValidator, field: :examination_id

    belongs_to :examination, foreign_key: "examination_id"
    has_many :perscription_drug
    has_many :drug, through: :perscription_drug
end
