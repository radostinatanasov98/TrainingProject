class PerscriptionDrug < ApplicationRecord
  validates :perscription_id, :drug_id, :usage_description, presence: true

  belongs_to :perscription, foreign_key: 'perscription_id'
  belongs_to :drug, foreign_key: 'drug_id'
end
