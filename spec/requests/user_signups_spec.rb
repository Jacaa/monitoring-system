require 'rails_helper'

RSpec.describe "User", type: :request do

  before(:each) do
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
  end

  it "signups using google oauth" do
    get '/'
    expect(response).to render_template(:index)
    # First login using google account
    expect { get '/auth/google_oauth2/callback' }.to change(User, :count).by(1)
    expect(response).to redirect_to root_url
    follow_redirect!
    expect(response).to render_template(:index)
    # Logout
    delete '/logout'
    # Login again with the same account
    expect { get '/auth/google_oauth2/callback' }.to_not change(User, :count)
    expect(response).to redirect_to root_url
  end
end