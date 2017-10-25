require 'rails_helper'

RSpec.describe "home/index.html.haml", type: :view do
  
  it "displays the camera view and login button" do
    render
    expect(rendered).to have_selector(".google")
    expect(rendered).to have_selector("#camera-view")
  end
end
