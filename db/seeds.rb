# frozen_string_literal: true

Faker::Config.locale = 'en'

10.times do
  User.create!(first_name: Faker::Name.first_name,
               second_name: Faker::Name.second_name,
               email: Faker::Internet.email,
               password: '123456')
end

10.times do |_x|
  Upload.create!(title: Faker::Lorem.sentences(number: 1),
                 description: Faker::Lorem.paragraph(sentence_count: 2),
                 body: Faker::Lorem.paragraph(sentence_count: 5),
                 user_id: 2)
end

10.times do
  Tag.create!(title: Faker::Hipster.word)
end

Role.create!(name: 'admin')
