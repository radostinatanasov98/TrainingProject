class OauthAccessToken < ApplicationRecord
  scope :recent_records, -> { where("DATETIME(created_at) > #{Time.current.utc - 13.hours}") }
end
