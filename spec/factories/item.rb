FactoryBot.define do
  factory :item do
    merchant
    name { |n| "Item #{n}" }
    description { |n| "Item #{n}" }
    price { |n| n*1.5 }
    inventory { |n| n*10 }
    active { true }
  end
end
