# frozen_string_literal: true

10.times do
  user = User.create!(first_name: FFaker::Name.first_name,
               last_name: FFaker::Name.last_name,
               email: FFaker::Internet.email,
               password: '123456')
  user.save!
end

sample_user = User.create!(first_name: "Michael",
             last_name: "Basmanov",
             email: "puglet5@mail.ru",
             password: '123456')
sample_user.save!

Role.create!(name: 'admin')

sample_user.add_role("admin")

PublicActivity.enabled = false

users = User.order(:created_at).take(5)
10.times do
  title = FFaker::Lorem.sentence
  description = FFaker::Lorem.paragraph
  body = FFaker::Lorem.paragraph
  status = "draft"
  users.each do |user|
     up = Upload.create!(title: title, description: description, body: body, status: status, user_id: user.id)
     up.thumbnail.attach(io: File.open(File.join(Rails.root,'public/images/rose.jpg')), filename: 'rose.jpg')
  end
end


