class UsersController < ApplicationController
  before_action :administrator_validation
  skip_before_action :verify_authenticity_token

  def all
    @Users = User.all
  end

  def show
    @User = User.find_by(email: params[:email])
  end

  def create
    @User = User.new
  end

  def update
    @User = User.find_by(id: params[:id])
  end

  def put
    user = User.find_by(id: user_params[:id])

    if user.update(
      email: user_params[:email],
      first_name: user_params[:first_name],
      last_name: user_params[:last_name],
      address: user_params[:address],
      date_of_birth: user_params[:date_of_birth],
      role_id: user_params[:role_id]
    )
      redirect_to action: 'show', email: user.email
    else
      render(json: { error: user.errors.full_messages }, status: 422)
    end
  end

  def new
    user = User.new(email: user_params[:email], password: user_params[:password],
                    first_name: params[:first_name], last_name: params[:last_name],
                    address: params[:address], date_of_birth: params[:date_of_birth], role_id: user_params[:role_id])

    if user.save
      redirect_to action: 'show', email: user.email
    else
      render(json: { error: user.errors.full_messages }, status: 422)
    end
  end

  def destroy
    user = User.find_by(id: params[:id])
    user.destroy
    redirect_to action: 'all'
  end

  private

  def user_params
    params.permit(:id, :email, :password, :first_name, :last_name, :address, :date_of_birth, :role_id)
  end

  def administrator_validation
    raise "#{current_user.role_id}!" unless current_user.role_id == 1
  end
end
