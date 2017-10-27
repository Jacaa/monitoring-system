require "rails_helper"

RSpec.feature "User" do
  
  describe "actions:" do
    scenario "login using google oauth2" do
      visit '/'
      expect(page).to have_link("GOOGLE")
      expect(page).to have_css('#camera-view')
      mock_omniauth
      click_link("GOOGLE")
      expect(page).to have_link("Logout")
      expect(page).to have_css('.alert')
      expect(page).to have_css('#camera-view')
      expect(page).to have_css('#data-tables')
      expect(page).to have_content("example@email.com")
    end
  end
end