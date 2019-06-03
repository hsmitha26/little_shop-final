FactoryBot.define do
  factory :home, class: Address do
    user
    sequence(:address) { |n| "Home Address #{n}" }
    sequence(:city) { |n| "Home City #{n}" }
    sequence(:state) { |n| "Home State #{n}" }
    sequence(:zip) { |n| "Zip #{n}" }
    nickname { 'home' }
  end

  factory :work, parent: :home do
    user
    sequence(:address) { |n| "Work Address #{n}" }
    sequence(:city) { |n| "Work City #{n}" }
    sequence(:state) { |n| "Work State #{n}" }
    nickname { 'work' }
  end
end
