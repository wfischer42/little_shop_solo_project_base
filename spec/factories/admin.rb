FactoryBot.define do
  factory :admin, class: User do
    email { |n| "admin_#{n}@gmail.com" }
    passowrd { |n| "Password #{n}" }
    name { |n| "Admin #{n}" }
    address { |n| "Address #{n}" }
    city { |n| "City #{n}" }
    state { |n| "State #{n}" }
    zip { |n| "Zip #{n}" }
    role { 2 }
    active { true }
  end
end
