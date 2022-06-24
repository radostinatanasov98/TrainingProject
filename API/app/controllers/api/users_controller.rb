require 'http'

module Api
  class UsersController < Api::ApplicationController
    skip_before_action :doorkeeper_authorize!, only: %i[create]

    respond_to :json

    def patients
      render json: User.where(role_id: 2)
    end

    def get_user
      return render json: 'Unprocessable Entity.', status: 422 unless params[:id]

      user = User.select(:first_name, :last_name, :email, :role_id, :id).find_by(id: params[:id])

      return render json: 'Unprocessable Entity.', status: 422 unless user

      render json: user
    end

    def create
      user = User.new(email: user_params[:email], password: user_params[:password],
                      first_name: params[:first_name], last_name: params[:last_name],
                      address: params[:address], date_of_birth: params[:date_of_birth], role_id: 2)

      client_app = Doorkeeper::Application.find_by(uid: params[:client_id])

      return render(json: { error: 'Invalid client ID' }, status: 403) unless client_app

      if user.save
        access_token = Doorkeeper::AccessToken.create(
          resource_owner_id: user.id,
          application_id: client_app.id,
          refresh_token: generate_refresh_token,
          expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
          scopes: ''
        )

        render(json: {
                 user: {
                   id: user.id,
                   email: user.email,
                   access_token: access_token.token,
                   token_type: 'bearer',
                   expires_in: access_token.expires_in,
                   refresh_token: access_token.refresh_token,
                   created_at: access_token.created_at.to_time.to_i
                 }
               })
      else
        render(json: 'Unprocessable Entity.', status: 422)
      end
    end

    private

    def user_params
      params.permit(:email, :password, :first_name, :last_name, :address, :date_of_birth, :client_id)
    end

    def generate_refresh_token
      loop do
        token = SecureRandom.hex(32)
        break token unless Doorkeeper::AccessToken.exists?(refresh_token: token)
      end
    end
  end
end
