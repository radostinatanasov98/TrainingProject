require 'net/http'
require 'cgi'
require 'constants'

class ApplicationController < ActionController::Base
    helper_method :json_parse
    
    def authenticate
        if self.is_authenticated?
            if self.should_refresh?
                if !self.refresh
                    cookies.delete :tokens
                    return redirect_to controller: 'users', action: 'log_in'
                end
            end
            return true
        else
            return redirect_to controller: 'users', action: 'log_in'
        end

    end

    def is_authenticated? 
        if cookies['tokens'] != nil && cookies['tokens'] != ''
            return true
        else
            return false
        end
    end

    def should_refresh?
        if Time.current.utc.to_i >= JWT.decode(self.json_parse(cookies['tokens'])['jwt'], nil, false)[0]['exp'].to_i
            return true
        end
    end

    def is_doctor?
        if self.is_authenticated?
            if self.role == 'doctor'
                return true
            else
                return render json: '400 Bad Request', status: 400
            end
        end
        return redirect_to controller: 'users', action: 'log_in'
    end

    def is_patient?
        if self.is_authenticated?
            if self.role == 'patient'
                return true
            elsif self.role == 'doctor'
                return redirect_to controller: 'patients', action: 'all'
            end
        end
        return redirect_to controller: 'users', action: 'log_in'
    end 
    
    def role
        return JWT.decode(self.json_parse(cookies['tokens'])['jwt'], nil, false)[0]['user']['role']
    end

    def refresh
            tokens = self.json_parse(cookies[:tokens])

            url = Constants.tokens_url
            uri = URI(url)
            http = Net::HTTP.new(uri.host, 3000)
            request = Net::HTTP::Post.new(uri.request_uri)
        
            request.body = {
                grant_type: 'refresh_token',
                client_id: Rails.application.credentials.dig(:aws, :access_key_id),
                client_secret: Rails.application.credentials.dig(:aws, :secret_access_key),
                refresh_token: tokens['refresh_token']}.to_json

            request['tokens'] = cookies['tokens']
        
            request['Content-Type'] = "application/json"
            request['User-App'] = "UserApp"
            request['Authorization'] = 'Bearer ' + tokens['jwt']

            req = http.request(request)

            if !req.kind_of? Net::HTTPSuccess
                return false
            end

            first_index = req['set-cookie'].index('=') + 1
            last_index = req['set-cookie'].index(';')
            escaped_value = req['set-cookie'][first_index...last_index]
            cookies['tokens'] = {
                value: escaped_value,
                httponly: true
            }

            return true
    end

    def json_parse(json)
        return JSON.parse(CGI::unescape(json))
    end
end