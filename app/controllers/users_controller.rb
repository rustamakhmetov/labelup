class UsersController < ApplicationController
  include Errors::RescueError

  before_action :load_user, only: %i(show update destroy)

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

  def update
    if @user.update(user_params)
      render json: @user.to_json
    else
      render json: { errors: @user.errors.full_messages }, status: 422
    end
  end

  def destroy
    @user.destroy
    head :ok
  end

  private

  def load_user
    @user = UserLogic.find(params[:id])
  end

  def user_params
    begin
      kind = @user ? @user.to_kind : params[:user][:kind].to_sym
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


