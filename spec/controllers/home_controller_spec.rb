require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "assigns @events variable" do
      5.times { create(:event) }
      get :index
      events = Event.all
      expect(assigns(:events)).to eq(events)
    end
  end

  describe "GET #cookies" do
    it "returns http success" do
      get :cookies_eu
      expect(response).to have_http_status(:success)
    end

    it "renders the index template" do
      get :cookies_eu
      expect(response).to render_template(:cookies_eu)
    end
  end
end
