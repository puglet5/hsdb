50.times do |x|
  Upload.create!(title: Faker::Lorem.sentences(number: 1),
                 description: Faker::Lorem.paragraph(sentence_count: 2),
                 body: Faker::Lorem.paragraph(sentence_count: 5),
                 user_id: 2)
end
