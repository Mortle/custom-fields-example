FactoryBot.define do
  factory :custom_field_value do
    association :fieldable, factory: :user
    custom_field
    value { Faker::Lorem.sentence }
  end
end
