# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

user = FactoryBot.create(:user, username: 'test', email: 'test@example.com', password: 'secret', first_name: 'Test')
users1 = FactoryBot.create_list(:user, 5)
users2 = FactoryBot.create_list(:user, 5)
user1 = users1.sample
user2 = users2.sample
FactoryBot.create_list(:tweet, 5, user: user1)
FactoryBot.create_list(:tweet, 5, user: user)
tweets = FactoryBot.create_list(:tweet, 5, user: user2)
users1.each do |u|
  FactoryBot.create(:like, user: u, tweet: tweets.sample)
end
