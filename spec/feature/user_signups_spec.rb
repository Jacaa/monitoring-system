require "rails_helper"

RSpec.feature "user" do

  describe "login" do
    scenario "using google oauth2" do
      visit '/'
      expect(page).to have_link("GOOGLE")
      click_link("GOOGLE")
      expect(page).to have_link("Logout")
      expect(page).to have_content("example@email.com")
    end
  end
end