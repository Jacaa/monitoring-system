require 'rails_helper'

RSpec.describe Event, type: :model do
  
  it "defualt scope should returns last event first" do
    first = create(:event)
    second = create(:event)
    expect(Event.all).to eq([second, first])
  end
end
