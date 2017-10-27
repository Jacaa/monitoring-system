require 'rails_helper'

RSpec.describe "Routes" do
  
  describe "for Home controller" do
    it "GET '/' routes to the index action" do
      expect(get("/")).to route_to("home#index")
    end

    it "GET '/cookies' routes to the cookies_eu action" do
      expect(get("/cookies")).to route_to("home#cookies_eu")
    end
  end

  describe "for Sessions controller" do
    it "GET '/auth/google_oauth2/callback' to the create action" do
      expect(get("/auth/google_oauth2/callback")).to route_to("sessions#create")
    end

    it "DELETE '/logout' to the destroy action" do
      expect(delete("/logout")).to route_to("sessions#destroy")
    end
  end
end