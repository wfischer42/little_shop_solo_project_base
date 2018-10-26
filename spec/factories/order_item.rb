FactoryBot.define do
  factory :order_item do
    order
    item
    quantity { |n| n*2 }
    price { |n| n*1.5 }
  end
end
