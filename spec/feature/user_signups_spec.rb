require "rails_helper"

RSpec.feature "User" do
  
  describe "login:" do
    
    scenario "using google oauth2" do
      visit '/'
      expect(page).to have_link("GOOGLE")
      expect(page).to have_css('#camera-view')
      mock_omniauth
      click_link("GOOGLE")
      expect(page).to have_link("Logout")
      expect(page).to have_css('.alert')
      expect(page).to have_css('#camera-view')
      expect(page).to have_css('#events')
      expect(page).to have_content("example@email.com")
    end
  end

  describe "actions:" do

    before(:each) do
      user = create(:user)
      visit '/'
      mock_omniauth
      click_link("GOOGLE")
      visit "/users/#{user.id}/edit"
    end

    scenario "update profile" do
      check("Send notification")
      check("Save photo")
      click_button("Save")
      expect(page).to have_content("Profile updated")
    end

    scenario "delete profile" do
      click_link("Delete profile")
      expect(page).to have_content("Profile deleted!")
    end
  end
end