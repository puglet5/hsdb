# frozen_string_literal: true

require 'faker'

10.times do
  user = User.create!(first_name: Faker::Name.first_name,
                      last_name: Faker::Name.last_name,
                      email: Faker::Internet.email,
                      password: '123456')
end

sample_user = User.create!(first_name: 'Michael',
                           last_name: 'Basmanov',
                           email: 'puglet5@mail.ru',
                           password: '123456')

sample_user.avatar.attach(io: File.open('public/images/rose.jpg'), filename: 'rose.jpg')

Role.create!(name: 'admin')

sample_user.add_role('admin')

PublicActivity.enabled = false

users = User.order(:created_at).take(5)
2.times do
  title = Faker::Lorem.sentence
  description = Faker::Lorem.paragraph
  body = Faker::Lorem.paragraph
  status = 'draft'
  metadata = Faker::Json.shallow_json(width: 3, options: { key: 'Science.element', value: 'Number.decimal(l_digits: 3, r_digits: 3)' })
  users.each do |user|
    up = Upload.create!(title: title, description: description, body: body, status: status, user_id: user.id)
    up.thumbnail.attach(io: File.open('public/images/rose.jpg'),
                        filename: 'rose.jpg')
    up.update!(metadata: metadata)
  end
end

Category.create!(category_name: 'Info', pinned: true)
Category.create!(category_name: 'Support', pinned: true)
Category.create!(category_name: 'Other', pinned: true)

5.times do
  post = Discussion.create!(title: Faker::Lorem.sentence, category_id: rand(1..3), user_id: users[rand(0..4)].id, pinned: [true, false].sample)

  ActionText::RichText.create!(record_type: 'Discussion', record_id: post.id, name: 'content', body: Faker::Lorem.sentence)
end
