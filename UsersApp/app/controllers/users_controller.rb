require 'http'
require 'constants'

class UsersController < ApplicationController
  before_action :authenticate
  skip_before_action :authenticate, only: %i[log_in]

  def profile
    json = json_parse(cookies['tokens'])
    id = params[:id]
    user_id = JWT.decode(json['jwt'], nil, false)[0]['user']['id']

    if [nil, '0'].include?(id)
      id = user_id
    elsif id != user_id.to_s && !is_doctor?
      redirect_to controller: 'users', action: 'profile', id: user_id
    end

    user_res = HTTP.cookies(tokens: cookies[:tokens])
                   .auth("Bearer #{json['jwt']}")
                   .get(Constants.user_by_id_url + "/#{id}")

    @user = JSON.parse(user_res.body)

    return redirect_to controller: 'patients', action: 'all' if @user['role_id'] == 3 && Integer(id) == @user['id']

    examinations_res = HTTP.auth("Bearer #{json['jwt']}")
                           .get(Constants.examinations_by_id_url + "/#{id}")

    @examinations = JSON.parse(examinations_res.body)
  end

  def log_in
    redirect_to controller: 'users', action: 'profile' if !cookies['tokens'].nil? && cookies['tokens'] != ''
  end

  private

  def login_params
    params.permit(:email, :password)
  end
end
