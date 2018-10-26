FactoryBot.define do
  factory :merchant, class: User do
    email { |n| "merchant_#{n}@gmail.com" }
    passowrd { |n| "Password #{n}" }
    name { |n| "Name #{n}" }
    address { |n| "Address #{n}" }
    city { |n| "City #{n}" }
    state { |n| "State #{n}" }
    zip { |n| "Zip #{n}" }
    role { 1 }
    active { true }
  end
end
