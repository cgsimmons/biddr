FactoryGirl.define do
  factory :bid do
    user
    auction
    price { 1 + rand(10) }
  end
end
