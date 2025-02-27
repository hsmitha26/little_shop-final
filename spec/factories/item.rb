FactoryBot.define do
  factory :item do
    association :user, factory: :merchant
    sequence(:name) { |n| "Item Name #{n}" }
    sequence(:description) { |n| "Description #{n}" }
    image {"https://picsum.photos/200/300"}
    sequence(:price) { |n| ("#{n}".to_i+1)*1.5 }
    sequence(:inventory) { |n| ("#{n}".to_i+1)*2 }
    active { true }
  end

  factory :inactive_item, parent: :item do
    association :user, factory: :merchant
    sequence(:name) { |n| "Inactive Item Name #{n}" }
    active { false }
  end
end
