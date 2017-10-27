require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "welcome" do
    
    let(:user) { create(:user) }
    let(:mail) { UserMailer.welcome(user)}

    it "renders the headers" do
      expect(mail.subject).to eq("Welcome!")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["noreply@monitoring.system.com"])
    end

    it "renders the body" do
      msg = "You have just signed up to the monitoring system."
      expect(mail.body.encoded).to include(msg)
    end
  end

end
