require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe "GET #create" do

    before(:each) do
      # True, cuz it is controller test
      mock_omniauth(true)
      get :create
    end

    it "returns http 302 Found" do
      expect(response).to have_http_status(302)
    end

    it "redirects to the root" do
      expect(response).to redirect_to(root_url)
    end
  
    it "sets cookies" do
      expect(cookies[:user_id]).not_to be_nil
      expect(cookies[:remember_token]).not_to be_nil
    end
  end
  
  describe "DELETE #destroy" do
    it "deletes cookies" do
      cookies['user_id'] = 'not_nil'
      cookies['remember_token'] = 'valid_token'
      delete :destroy
      expect(response.cookies['user_id']).to be_nil
      expect(response.cookies['remember_token']).to be_nil
    end
  end
end
