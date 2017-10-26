require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do

  describe "current_user" do
    
    before(:each) do
      @user = create(:user)
    end
    
    it "returns right user" do
      log_in @user
      expect(current_user).to eq(@user)
    end

    it "returns nil when cookies is nil" do
      log_out
      expect(current_user).to be_nil
    end

    it "return nil when remember_token is wrong" do
      log_in @user
      @user.update_attribute(:remember_token, User.new_token)
      expect(current_user).to be_nil
    end
  end
end
