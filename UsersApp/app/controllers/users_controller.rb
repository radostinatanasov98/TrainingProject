require 'http'
require 'constants'

class UsersController < ApplicationController
    before_action :authenticate
    skip_before_action :authenticate, only: %i[log_in]

    def profile
        json = self.json_parse(cookies['tokens'])
        id = params[:id]
        user_id = JWT.decode(json['jwt'], nil, false)[0]['user']['id']
  
        if id == nil || id == '0'
            id = user_id
        elsif id != user_id.to_s && !self.is_doctor?
            redirect_to controller: 'users', action: 'profile', id: user_id       
        end  

        user_res = HTTP.cookies(:tokens => cookies[:tokens])
        .auth("Bearer #{json['jwt']}")
        .get(Constants.user_by_id_url, :params => { id: id })
        
        @user = JSON.parse(user_res.body)
        
        if @user['role_id'] == 3 && Integer(id) == @user['id']
            return redirect_to controller: 'patients', action: 'all'
        end

        examinations_res = HTTP.auth("Bearer #{json['jwt']}")
        .get(Constants.examinations_by_id_url, :params => {id: id})

        @examinations = JSON.parse(examinations_res.body) 
    end

    def log_in
        if cookies['tokens'] != nil && cookies['tokens'] != ''
            redirect_to controller: 'users', action: 'profile'
        end
    end

    private

    def login_params
        params.permit(:email, :password)
    end
end