FactoryBot.define do
  factory :address, class: Address do
    user
    sequence(:street) { |n| "Home Address #{n}" }
    sequence(:city) { |n| "Home City #{n}" }
    sequence(:state) { |n| "Home State #{n}" }
    sequence(:zip) { |n| "Zip #{n}" }
  end
end
