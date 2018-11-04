FactoryBot.define do
  factory :inventory_item do
    association :merchant, factory: :merchant
    association :item, factory: :item
    sequence(:inventory) { |n| (n + 1) * 2 }
    sequence(:markup) { |n| (n * 0.05) }
  end
end
