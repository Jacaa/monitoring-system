require 'rails_helper'

RSpec.describe "Routes" do
  
  describe "for Home controller" do
    it "GET '/' routes to the index action" do
      expect(get("/")).to route_to("home#index")
    end
  end
end