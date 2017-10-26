require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  # describe "GET #create" do

  #   before(:each) do
  #     request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
  #     get :create
  #   end

  #   it "returns http success" do
  #     expect(response).to have_http_status(:success)
  #   end

  #   it "renders the index template" do
  #     expect(response).to render_template(:index)
  #   end
  
  #   it "sets cookies" do
  #     expect(response.cookies[:user_id]).not_to be_nil
  #     expect(response.cookies[:remember_token]).not_to be_nil
  #   end
  # end
  
  describe "DELETE #destroy" do
    it "deletes cookies" do
      request.cookies['user_id'] = 'not_nil'
      request.cookies['remember_token'] = 'valid_token'
      delete :destroy
      expect(response.cookies['user_id']).to be_nil
      expect(response.cookies['remember_token']).to be_nil
    end
  end
end
