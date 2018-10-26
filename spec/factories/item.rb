FactoryBot.define do
  factory :item do
    association :user, factory: :merchant
    sequence(:name) { |n| "Name #{n}" }
    sequence(:description) { |n| "Description #{n}" }
    sequence(:image) { |n| "Image #{n}" }
    sequence(:price) { |n| ("#{n}".to_i+1)*1.5 }
    sequence(:inventory) { |n| ("#{n}".to_i+1)*10 }
    active { true }
  end

  factory :Inactive_item, parent: :item do
    association :user, factory: :merchant
    sequence(:name) { |n| "Name #{n}" }
    sequence(:description) { |n| "Description #{n}" }
    sequence(:image) { |n| "Image #{n}" }
    sequence(:price) { |n| ("#{n}".to_i+1)*1.5 }
    sequence(:inventory) { |n| ("#{n}".to_i+1)*10 }
    active { false }
  end
end
