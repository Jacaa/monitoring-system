require 'rails_helper'

RSpec.describe User, type: :model do
  
  it "creates itself from an omniauth hash" do
    omniauth_hash = { :provider => 'google_oauth2',
                      :uid => '54321',
                      :info => {
                          :name => 'name',
                          :email => 'example@email.com',
                          :nickname => 'nickname'
                      }
                    }
    User.create_user(omniauth_hash)
    user = User.last
    expect(user.provider).to eq('google_oauth2')
    expect(user.uid).to eq('54321')
    expect(user.email).to eq('example@email.com')
  end

  # Remember token
  it "should generate remember token before create new user" do
    user = create(:user)
    expect(user.remember_token).not_to be_nil
  end
end
