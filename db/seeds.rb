# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
password = "password"
5.times do
  user = User.new
  user.first_name = Faker::Name.first_name
  user.last_name = Faker::Name.last_name
  user.email = Faker::Internet.email
  user.password_digest = User.new(:password => password).password_digest
  user.save
end
puts "Seeded users."

10.times do
  Auction.create(
    title: Faker::Commerce.product_name,
    details: Faker::Hacker.say_something_smart + " " + Faker::ChuckNorris.fact + " " + Faker::Lorem.paragraph,
    reserve_price: 10 + rand(15),
    user: User.all.sample,
    end_date: Faker::Time.between(Date.today,  Date.today + 2.months, :all),
    created_at: Faker::Time.between(2.months.ago, Date.today, :all),
    aasm_state: ["draft", "published"].sample)
  # random = rand(10)
  # price = 1 + rand(5)
  # random.times do
  #   price += 1 + rand(5)
  #   date = auction.current_bidder.present? ? auction.current_bidder.created_at : auction.created_at
  #   Bid.create(
  #                 auction: auction,
  #                 user: User.all.sample,
  #                 price: price,
  #                 created_at: Faker::Time.between(date, Date.today, :all))
  # end
end
puts 'Seeded auctions'
