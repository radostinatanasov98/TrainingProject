module Constants 
    def self.api_url
        if ENV.fetch("RAILS_ENV") == "dockerized_development"
            "http://trainingproject-api-1:3000/"
        else
            "http://localhost:3000/"
        end
    end

    def self.tokens_url
        "#{self.api_url}oauth/token"
    end

    def self.user_by_id_url
        "#{self.api_url}api/users/get_user"
    end

    def self.examinations_by_id_url
        "#{self.api_url}api/examinations/get_by_id"
    end

    def self.all_patients_url
        "#{self.api_url}api/get_patients"
    end

    def self.all_drugs_url
        "#{self.api_url}api/get_drugs"
    end
end