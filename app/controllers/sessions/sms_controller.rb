class Sessions::SmsController < ApplicationController
  skip_before_action :authenticate

  def new; end

  def create
    @user = User.find_by_token_for!(:sms_authentication, params[:sid])
    if @user.authenticate_otp(params[:otp_code], drift: 60)
      @session = @user.sessions.create!
      cookies.signed.permanent[:session_token] = { value: @session.id, httponly: true }

      redirect_to root_path, notice: 'Signed in successfully'
    else
      flash.now[:alert] = 'Invalid OTP code'
      render :new, status: :unprocessable_entity
    end
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to sign_in_path, notice: 'Please try log in again'
  end
end
