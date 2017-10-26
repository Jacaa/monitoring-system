require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  OmniAuth.config.test_mode = true
  omniauth_hash = { 'provider' => 'google_oauth2',
                    'uid' => '12345',
                    'info' => {
                        'name' => 'name',
                        'email' => 'example@email.com',
                        'nickname' => 'nickname'
                    }
  }
  OmniAuth.config.add_mock(:google, omniauth_hash)

  describe "GET #create" do

    # before(:each) do
    #   request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google]
    #   get :create
    # end

    # it "returns http success" do
    #   expect(response).to have_http_status(:success)
    # end

    # it "renders the index template" do
    #   expect(response).to render_template(:index)
    # end
  end
end
