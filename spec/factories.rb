# This will guess the User class
FactoryBot.define do
  factory :user do
    email "example@email.com"
    provider "google_oauth2"
    uid '12345'
  end
end