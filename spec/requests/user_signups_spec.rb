require 'rails_helper'

RSpec.describe "User", type: :request do

  it "signups using google_oauth2" do
    get '/'
    expect(response).to render_template(:index)
    # First login using google account
    mock_omniauth
    expect { get '/auth/google_oauth2/callback' }.to change(User, :count).by(1)
    expect(response.cookies['user_id']).not_to be_nil
    expect(response.cookies['remember_token']).not_to be_nil
    expect(response).to redirect_to root_url
    follow_redirect!
    expect(response).to render_template(:index)
    # Logout
    delete '/logout'
    expect(response.cookies['user_id']).to be_nil
    expect(response.cookies['remember_token']).to be_nil
    # Login again with the same account
    expect { get '/auth/google_oauth2/callback' }.to_not change(User, :count)
    expect(response).to redirect_to root_url
  end
end