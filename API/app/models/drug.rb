class Drug < ApplicationRecord
  has_many :perscription_drug
  has_many :perscription, through: :perscription_drug
end
