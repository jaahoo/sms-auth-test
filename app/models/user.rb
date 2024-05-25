class User < ApplicationRecord
  has_one_time_password

  generates_token_for :sms_verification, expires_in: 10.minutes do
    phone
  end

  generates_token_for :sms_authentication, expires_in: 5.minutes do
    phone
  end

  has_many :sessions, dependent: :destroy

  validates :phone, presence: true, uniqueness: true, format: { with: /\A[1-9][0-9]{8}\z/ }
  validates :email, uniqueness: true, allow_nil: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  normalizes :phone, with: -> { _1.strip.gsub(' ', '').last(9) }
  normalizes :email, with: -> { _1.strip.downcase }

  # before_create :generate_otp_secret
  before_validation if: :phone_changed?, on: :update do
    self.verified = false
  end

  def send_otp
    # Integrate with Twilio or any SMS service to send the otp_code
    puts '╔═SMSOTP═╗'
    puts "║ #{otp_code} ║"
    puts '╚════════╝'
  end
end
