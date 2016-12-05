FactoryGirl.define do
  factory :auction do
    sequence(:title) { |n| "#{Faker::Commerce.product_name} #{n}"}
    details Faker::Company.catch_phrase
    end_date Faker::Time.between(Date.today, Date.today + 3.months)
    reserve_price {10 + rand(100)}
    user
  end
end
