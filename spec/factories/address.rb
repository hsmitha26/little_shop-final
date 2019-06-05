FactoryBot.define do
  factory :address, class: Address do
    user
    sequence(:nickname) { |n| "Nickname #{n}" }
    sequence(:street) { |n| "Address #{n}" }
    sequence(:city) { |n| "City #{n}" }
    sequence(:state) { |n| "State #{n}" }
    sequence(:zip) { |n| "Zip #{n}" }
  end
end
