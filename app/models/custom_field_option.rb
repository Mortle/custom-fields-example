# == Schema Information
#
# Table name: custom_field_options
#
#  id              :bigint           not null, primary key
#  value           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  custom_field_id :bigint           not null
#
# Indexes
#
#  index_custom_field_options_on_custom_field_id  (custom_field_id)
#
# Foreign Keys
#
#  fk_rails_...  (custom_field_id => custom_fields.id)
#
class CustomFieldOption < ApplicationRecord
  belongs_to :custom_field

  validates :value, presence: true, uniqueness: { scope: :custom_field_id }
end
