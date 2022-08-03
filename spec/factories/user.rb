# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  first_name             :string           not null
#  last_name              :string
#  organization           :string
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  slug                   :string
#  bio                    :text

FactoryBot.define do
  factory :user do
    sequence(:id) { |n| n }
    first_name { 'test' }
    last_name { 'user' }
    password { '123456' }
    sequence(:email) { |n| "test#{n}@test.com" }

    factory :default_user do
      after(:create) { |user| user.add_role(:default) }
    end

    factory :admin_user do
      after(:create) { |user| user.add_role(:admin) }
    end
  end
end
