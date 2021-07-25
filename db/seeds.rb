10.times do |upload|
  Upload.create!(
    title: "Upload #{upload}",
    description: "Laborum excepteur cupidatat veniam voluptate deserunt commodo ipsum. Qui in incididunt nostrud ut non incididunt velit. Aliquip velit consequat sunt reprehenderit minim reprehenderit. Dolore tempor ut esse mollit consectetur eu ipsum irure pariatur voluptate. Commodo ipsum qui non nulla nulla.",
    user_id: 2,
  )
end

puts "10 uploads created"
