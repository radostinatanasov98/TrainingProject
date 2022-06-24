module Api
  class ApplicationController < ActionController::API
    include ::ActionController::Cookies

    before_action :doorkeeper_authorize!
    respond_to :json
  end
end
