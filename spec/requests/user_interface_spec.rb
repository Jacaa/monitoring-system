require 'rails_helper'

RSpec.describe "User", type: :request do

  before(:each) do
    ActionMailer::Base.deliveries.clear
  end

  it "signups using google_oauth2" do
    get '/'
    expect(response).to render_template(:index)
    # First login using google account
    mock_omniauth
    expect { get '/auth/google_oauth2/callback' }.to change(User, :count).by(1)
    expect(ActionMailer::Base.deliveries.size).to eq(1)
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
    expect(ActionMailer::Base.deliveries.size).to eq(1)
    expect(response).to redirect_to root_url
  end

  it "updates profile" do
    # Login user
    mock_omniauth
    get '/auth/google_oauth2/callback'
    # Visit edit page
    user = assigns(:user)
    get "/users/#{user.id}/edit"
    expect(response).to render_template(:edit)
    # Update profile
    patch "/users/#{user.id}", params: { user: {send_notification: true, 
                                                save_photo: true } }
    user.reload
    expect(user.send_notification).to eq(true)
    expect(user.save_photo).to eq(true)
    expect(response).to redirect_to edit_user_url
    follow_redirect!
    expect(response).to render_template(:edit)
  end

  it "deletes profile" do
    # Login user
    mock_omniauth
    get '/auth/google_oauth2/callback'
    # Delete profile
    user = assigns(:user)
    expect { delete "/users/#{user.id}" }.to change(User, :count).by(-1)
    expect(response).to redirect_to root_url
    follow_redirect!
    expect(response).to render_template(:index)
  end
end