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
class CustomField < ApplicationRecord
  has_many :custom_field_values, dependent: :destroy
  has_many :custom_field_options, dependent: :destroy

  enum field_type: { text: 0, number: 1, single_select: 2, multiple_select: 3 }

  validates :name, presence: true
  validates :field_type, presence: true, inclusion: { in: field_types.keys }
end
