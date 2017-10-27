class User < ApplicationRecord
  before_create { generate_remember_token }

  # Returns random token
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def self.sign_in_from_omniauth(auth)
    find_by(provider: auth["provider"], uid: auth["uid"])
  end

  def self.create_user(auth)
    create(provider: auth[:provider], uid: auth[:uid], email: auth[:info][:email])
  end

  def send_welcome_email
    UserMailer.welcome(self).deliver_now
  end
  
  private

    # Generate new remember token
    def generate_remember_token
      self[:remember_token] = User.new_token
    end
end
