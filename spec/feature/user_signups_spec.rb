require "rails_helper"

RSpec.feature "user" do
  
  before(:each) do
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
  end

  describe "login" do
    scenario "using google oauth2" do
      visit '/'
      expect(page).to have_link("GOOGLE")
      expect(page).to have_css('#camera-view')
      click_link("GOOGLE")
      expect(page).to have_link("Logout")
      expect(page).to have_css('#camera-view')
      expect(page).to have_css('#data-tables')
      expect(page).to have_content("example@email.com")
    end
  end
end