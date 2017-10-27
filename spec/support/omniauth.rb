def mock_omniauth
  OmniAuth.config.test_mode = true
  omniauth_hash = { 'provider' => 'google_oauth2',
                    'uid' => '12345',
                    'info' => {
                        'name' => 'name',
                        'email' => 'example@email.com',
                        'nickname' => 'nickname'
                    }
  }
  OmniAuth.config.add_mock(:google_oauth2, omniauth_hash)
  Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
end
