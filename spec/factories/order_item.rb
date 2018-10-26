FactoryBot.define do
  factory :order_item do
    order
    item
    quantity { |n| ("#{n}".to_i+1)*2 }
    price { |n| ("#{n}".to_i+1)*1.5 }
  end
end
