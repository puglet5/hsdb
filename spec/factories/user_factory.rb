# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  bio                    :text
#  created_at             :datetime         not null
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null, indexed
#  encrypted_password     :string           default(""), not null
#  first_name             :string           not null
#  id                     :bigint           not null, primary key
#  last_name              :string           not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  organization           :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string           indexed
#  sign_in_count          :integer          default(0), not null
#  slug                   :string
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
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
