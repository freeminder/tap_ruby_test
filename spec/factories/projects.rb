FactoryBot.define do
  factory :project do
    name { Faker::Book.title }
  end
end
