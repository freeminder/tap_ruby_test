FactoryBot.define do
  factory :role do
    name { ["Admin", "User"].sample }
  end
end
