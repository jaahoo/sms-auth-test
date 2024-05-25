class SessionsController < ApplicationController
  skip_before_action :authenticate, only: %i[new create]

  before_action :set_session, only: :destroy
  before_action :require_lock, only: :create

  def index
    @sessions = Current.user.sessions.order(created_at: :desc)
  end

  def new; end

  def create
    @user = User.find_by(phone: params[:phone_number])
    if @user
      @user.send_otp
      if @user.verified
        sid = @user.generate_token_for(:sms_authentication)
        redirect_to new_sessions_sms_path(sid:)
      else
        sid = @user.generate_token_for(:sms_verification)
        redirect_to new_identity_sms_verifications_path(sid:)
      end
    else
      flash.now[:alert] = 'Invalid phone number or user not verified'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @session.destroy
    redirect_to(sessions_path, notice: 'That session has been logged out')
  end

  private

  def set_session
    @session = Current.user.sessions.find(params[:id])
  end
end
