FactoryBot.define do
  factory :user, class: User do
    sequence(:email) { |n| "user_#{n}@gmail.com" }
    password { "password" }
    sequence(:name) { |n| "User Name #{n}" }
    active { true }
  end
  factory :inactive_user, parent: :user do
    sequence(:name) { |n| "Inactive User Name #{n}" }
    sequence(:email) { |n| "inactive_user_#{n}@gmail.com" }
    active { false }
  end

  factory :merchant, parent: :user do
    sequence(:email) { |n| "merchant_#{n}@gmail.com" }
    sequence(:name) { |n| "Merchant Name #{n}" }
    role { 1 }
    active { true }
  end
  factory :inactive_merchant, parent: :user do
    sequence(:email) { |n| "inactive_merchant_#{n}@gmail.com" }
    sequence(:name) { |n| "Inactive Merchant Name #{n}" }
    role { 1 }
    active { false }
  end

  factory :admin, parent: :user do
    sequence(:email) { |n| "admin_#{n}@gmail.com" }
    sequence(:name) { |n| "Admin Name #{n}" }
    role { 2 }
    active { true }
  end
end
