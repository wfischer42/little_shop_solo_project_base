FactoryBot.define do
  factory :item do
    user
    name { |n| "Name #{n}" }
    description { |n| "Description #{n}" }
    image { |n| "Image #{n}" }
    price { |n| ("#{n}".to_i+1)*1.5 }
    inventory { |n| ("#{n}".to_i+1)*10 }
    active { true }
  end
end
