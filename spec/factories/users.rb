FactoryBot.define do
  factory :user do
    password { 'password' }
    email { 'user@mail.com' }
  end
end
