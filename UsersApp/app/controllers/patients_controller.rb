require 'constants'

class PatientsController < ApplicationController
  before_action :authenticate
  before_action :is_doctor?

  def all
    res = HTTP.auth("Bearer #{json_parse(cookies[:tokens])['jwt']}")
              .get(Constants.all_patients_url)

    @patients = JSON.parse(res.body)
  end
end
