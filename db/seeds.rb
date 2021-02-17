User.create!(name:  "そろだ　たびお",
             email: "example@example.org",
             password:              "foobar",
             password_confirmation: "foobar")
             
users = User.order(:created_at).take(1)
10.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.posts.create!(content: content) }
end