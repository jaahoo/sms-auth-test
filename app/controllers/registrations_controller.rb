class RegistrationsController < ApplicationController
  skip_before_action :authenticate
  before_action :require_lock, only: :create

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_otp
      sid = @user.generate_token_for(:sms_verification)
      redirect_to new_identity_sms_verifications_path(sid:)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:phone)
  end
end
