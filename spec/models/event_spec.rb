require 'rails_helper'

RSpec.describe Event, type: :model do
  
  it "default scope should returns 10 latest events" do
    20.times { create(:event) }
    expect(Event.all.count).to eq(10)
  end

  it "defualt scope should returns last event first" do
    first = create(:event)
    second = create(:event)
    expect(Event.all).to eq([second, first])
  end
end
