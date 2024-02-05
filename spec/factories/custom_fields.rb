# == Schema Information
#
# Table name: custom_fields
#
#  id         :bigint           not null, primary key
#  field_type :integer          not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :custom_field do
    name { Faker::Lorem.word }
    field_type { CustomField.field_types.keys.sample }
  end
end
