FactoryBot.define do
  factory :user, class: User do
    email { |n| "user_#{n}@gmail.com" }
    password { |n| "Password #{n}" }
    name { |n| "Name #{n}" }
    address { |n| "Address #{n}" }
    city { |n| "City #{n}" }
    state { |n| "State #{n}" }
    zip { |n| "Zip #{n}" }
    role { 0 }
    active { true }
  end
  factory :inactive_user, parent: :user do
    email { |n| "user_#{n}@gmail.com" }
    password { |n| "Password #{n}" }
    name { |n| "Name #{n}" }
    address { |n| "Address #{n}" }
    city { |n| "City #{n}" }
    state { |n| "State #{n}" }
    zip { |n| "Zip #{n}" }
    role { 0 }
    active { false }
  end

  factory :merchant, parent: :user do
    email { |n| "merchant_#{n}@gmail.com" }
    password { |n| "Password #{n}" }
    name { |n| "Name #{n}" }
    address { |n| "Address #{n}" }
    city { |n| "City #{n}" }
    state { |n| "State #{n}" }
    zip { |n| "Zip #{n}" }
    role { 1 }
    active { true }
  end
  factory :inactive_merchant, parent: :user do
    email { |n| "merchant_#{n}@gmail.com" }
    password { |n| "Password #{n}" }
    name { |n| "Name #{n}" }
    address { |n| "Address #{n}" }
    city { |n| "City #{n}" }
    state { |n| "State #{n}" }
    zip { |n| "Zip #{n}" }
    role { 1 }
    active { false }
  end

  factory :admin, parent: :user do
    email { |n| "admin_#{n}@gmail.com" }
    password { |n| "Password #{n}" }
    name { |n| "Admin #{n}" }
    address { |n| "Address #{n}" }
    city { |n| "City #{n}" }
    state { |n| "State #{n}" }
    zip { |n| "Zip #{n}" }
    role { 2 }
    active { true }
  end
end
