FactoryBot.define do
  factory :order do
    user
    status { "pending" }
  end
  factory :fulfilled_order, parent: :order do
    user
    status { "fulfilled" }
  end
  factory :cancelled_order, parent: :order do
    user
    status { "cancelled" }
  end
  factory :disabled_order, parent: :order do
    user
    status { "disabled" }
  end
end
