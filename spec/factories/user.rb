FactoryBot.define do
  factory :user do
    first_name { 'test' }
    last_name { 'user' }
    email { 'test.user@example.com' }
    password { '123456' }
  end
end
