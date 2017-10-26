require 'rails_helper'

RSpec.describe "User", type: :request do

  before(:each) do
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google]
  end

  it "signups using google oauth" do
    get '/'
    expect(response).to render_template(:index)
    # First login using google account
    expect do
      get '/auth/google_oauth2'
    end.to change { User.count }.by(1)
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
    # Logout
    delete '/logout'
    # Login with invalid omniauth
    expect { get '/auth/google_oauth2/callback' }.to_not change(User, :count)
    expect(response).to redirect_to root_url
  end
end

# test "signup using oauth" do
#   # Signup using github
#   assert_difference 'User.count', 1 do
#     get '/auth/github/callback'
#   end
#   assert_equal 1, ActionMailer::Base.deliveries.size
#   auth = request.env['omniauth.auth']
#   assert_equal cookies['user_name'], auth['info']['name']
#   assert_equal cookies['user_image'], auth['info']['image']
#   assert user_is_logged_in?
#   assert_redirected_to root_url
#   # Logout
#   delete logout_path
#   assert_empty cookies['user_name']
#   assert_empty cookies['user_image']
#   assert_not user_is_logged_in?
#   # Login using github - no new record
#   assert_no_difference 'User.count' do
#     get '/auth/github/callback'
#   end
#   assert_equal 1, ActionMailer::Base.deliveries.size
#   assert user_is_logged_in?
#   # Logout
#   delete logout_path
#   # Try signup with google but with same email as github
#   assert_no_difference 'User.count' do
#     get '/auth/google_oauth2/callback'
#   end
#   assert_equal 1, ActionMailer::Base.deliveries.size
#   assert_not user_is_logged_in?
#   assert_not flash.empty?
#   assert_redirected_to root_path
#   # Signup with facebook and other email
#   assert_difference 'User.count', 1 do
#     get '/auth/facebook/callback'
#   end
#   assert_equal 2, ActionMailer::Base.deliveries.size
#   assert user_is_logged_in?
# end

