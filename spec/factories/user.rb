FactoryBot.define do
  factory :user do
    email { |n| "user_#{n}@gmail.com" }
    passowrd { |n| "Password #{n}" }
    name { |n| "Name #{n}" }
    address { |n| "Address #{n}" }
    city { |n| "City #{n}" }
    state { |n| "State #{n}" }
    zip { |n| "Zip #{n}" }
    role { 0 }
    active { true }
  end
end
