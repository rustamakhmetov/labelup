class UsersController < ApplicationController
  include Errors::RescueError

  before_action :load_user, only: %i(show)

  def create
    @user = UserLogic.create(params: user_params)
    if @user.persisted?
      render json: @user.to_json
    else
      render json: { errors: @user.errors.full_messages }, status: 422
    end
  end

  def show
    render json: @user.to_json
  end

  private

  def load_user
    @user = UserLogic.find(params[:id])
  end

  def user_params
    begin
      kind = params[:user][:kind].to_sym
      raise Errors::UnprocessableEntity, "Unknown user kind" unless UserLogic::ALLOW_KINDS.include?(kind)
      attrs = [:email, :phone, :name, :password, :kind]
      attrs << [:organization, :position] if kind == :advertiser
      params.require(:user).permit(attrs)
    rescue Errors::UnprocessableEntity => e
      raise Errors::UnprocessableEntity, e.message
    rescue
      raise Errors::UnprocessableEntity, "Invalid parameters"
    end
  end
end


