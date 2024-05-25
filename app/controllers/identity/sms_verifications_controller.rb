class Identity::SmsVerificationsController < ApplicationController
  skip_before_action :authenticate

  def new; end

  def create
    @user = User.find_by_token_for!(:sms_verification, params[:sid])
    if @user.authenticate_otp(params[:otp_code], drift: 60)
      @user.update(verified: true)
      @session = @user.sessions.create!
      cookies.signed.permanent[:session_token] = { value: @session.id, httponly: true }
      redirect_to root_path, notice: 'Phone number verified successfully. You are now signed in.'
    else
      flash.now[:alert] = 'Invalid OTP code'
      render :new, status: :unprocessable_entity
    end
  end
end
