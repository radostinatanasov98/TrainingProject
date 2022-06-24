module Constants
  def self.api_url
    if ENV.fetch('RAILS_ENV') == 'dockerized_development'
      'http://trainingproject-api-1:3000/'
    else
      'http://localhost:3000/'
    end
  end

  def self.tokens_url
    "#{api_url}oauth/token"
  end

  def self.user_by_id_url
    "#{api_url}api/users"
  end

  def self.examinations_by_id_url
    "#{api_url}api/examinations"
  end

  def self.all_patients_url
    "#{api_url}api/get_patients"
  end

  def self.all_drugs_url
    "#{api_url}api/get_drugs"
  end
end
