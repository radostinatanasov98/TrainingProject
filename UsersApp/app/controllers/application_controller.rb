require 'net/http'
require 'cgi'
require 'constants'

class ApplicationController < ActionController::Base
  helper_method :json_parse

  def authenticate
    if is_authenticated?
      if should_refresh? && !refresh
        cookies.delete :tokens
        return redirect_to controller: 'users', action: 'log_in'
      end
      true
    else
      redirect_to controller: 'users', action: 'log_in'
    end
  end

  def is_authenticated?
    if !cookies['tokens'].nil? && cookies['tokens'] != ''
      true
    else
      false
    end
  end

  def should_refresh?
    true if Time.current.utc.to_i >= JWT.decode(json_parse(cookies['tokens'])['jwt'], nil, false)[0]['exp'].to_i
  end

  def is_doctor?
    if is_authenticated?
      if role == 'doctor'
        return true
      else
        return render json: '400 Bad Request', status: 400
      end
    end
    redirect_to controller: 'users', action: 'log_in'
  end

  def is_patient?
    if is_authenticated?
      if role == 'patient'
        return true
      elsif role == 'doctor'
        return redirect_to controller: 'patients', action: 'all'
      end
    end
    redirect_to controller: 'users', action: 'log_in'
  end

  def role
    JWT.decode(json_parse(cookies['tokens'])['jwt'], nil, false)[0]['user']['role']
  end

  def refresh
    tokens = json_parse(cookies[:tokens])

    url = Constants.tokens_url
    uri = URI(url)
    http = Net::HTTP.new(uri.host, 3000)
    request = Net::HTTP::Post.new(uri.request_uri)

    request.body = {
      grant_type: 'refresh_token',
      client_id: Rails.application.credentials.dig(:aws, :access_key_id),
      client_secret: Rails.application.credentials.dig(:aws, :secret_access_key),
      refresh_token: tokens['refresh_token']
    }.to_json

    request['tokens'] = cookies['tokens']

    request['Content-Type'] = 'application/json'
    request['User-App'] = 'UserApp'
    request['Authorization'] = 'Bearer ' + tokens['jwt']

    req = http.request(request)

    return false unless req.is_a? Net::HTTPSuccess

    first_index = req['set-cookie'].index('=') + 1
    last_index = req['set-cookie'].index(';')
    escaped_value = req['set-cookie'][first_index...last_index]
    cookies['tokens'] = {
      value: escaped_value,
      httponly: true
    }

    true
  end

  def json_parse(json)
    JSON.parse(CGI.unescape(json))
  end
end
