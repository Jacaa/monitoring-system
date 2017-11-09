# This will guess the User class
FactoryBot.define do
  factory :user do
    email "example@email.com"
    provider "google_oauth2"
    uid '12345'
    admin true
    send_notification false
    save_photo false
  end

  factory :event do
    walked_in true
    photo 'photo'
  end
end