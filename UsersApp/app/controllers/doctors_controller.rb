require 'constants'
class DoctorsController < ApplicationController
  before_action :authenticate
  before_action :is_doctor?

  def create_examination
    return render json: '400 Bad Request', status: 400 if params[:id].nil?

    bearer = json_parse(cookies[:tokens])['jwt']
    user_res = HTTP.auth("Bearer #{bearer}")
                   .get(Constants.user_by_id_url + "/#{params[:id]}")

    @user = JSON.parse(user_res)

    res = HTTP.auth("Bearer #{bearer}")
              .get(Constants.all_drugs_url)

    @drugs = JSON.parse(res)
  end

  def post_examination
    res = request.body.read
    render json: JSON.parse
  end
end
