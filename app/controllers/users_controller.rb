class UsersController < ApplicationController
  before_action :load_user, only: %i(show)


  # def index
  #   users = User.all
  #   render json: users
  # end

  def create
  end

  def show
    render json: @user.to_json
  end

  private

  def load_user
    @user = UserLogic.find(params[:id])
  end
end
