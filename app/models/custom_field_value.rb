# == Schema Information
#
# Table name: custom_field_values
#
#  id              :bigint           not null, primary key
#  fieldable_type  :string           not null
#  value           :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  custom_field_id :bigint           not null
#  fieldable_id    :bigint           not null
#
# Indexes
#
#  index_custom_field_values_on_custom_field_id                  (custom_field_id)
#  index_custom_field_values_on_fieldable_type_and_fieldable_id  (fieldable_type,fieldable_id)
#
# Foreign Keys
#
#  fk_rails_...  (custom_field_id => custom_fields.id)
#
class CustomFieldValue < ApplicationRecord
  belongs_to :fieldable, polymorphic: true
  belongs_to :custom_field

  validates :value, presence: true
  validate -> { send("validate_field_type_#{custom_field.field_type}") if custom_field } # NOTE: type-specific validations, extendable

  private

  def validate_field_type_text
    # NOTE: expandable for text validations like length or absence of specific symbols
    ensure_single_value_per_fieldable
  end

  def validate_field_type_number
    ensure_single_value_per_fieldable

    errors.add(:value, 'must be a valid number') unless value =~ /^[+-]?(\d+\.?\d*|\.\d+)$/
  end

  def validate_field_type_single_select
    ensure_single_value_per_fieldable
    ensure_included_in_options
  end

  def validate_field_type_multiple_select
    ensure_included_in_options

    if custom_field.custom_field_values.where.not(id: id).where(fieldable_id: fieldable_id).exists?(value: value)
      errors.add(:value, "already exists in the list of CustomFieldValue's") # "this option is already selected"
    end
  end

  def ensure_included_in_options
    # WARN: make sure custom_field with its options are preloaded (to avoid N+1)
    unless custom_field.custom_field_options.where.not(id: id).pluck(:value).include?(value)
      errors.add(:value, "is not included in the list of options")
    end
  end

  def ensure_single_value_per_fieldable
    existing_values = custom_field.custom_field_values.where(fieldable: fieldable).where.not(id: id)
    if existing_values.exists?
      errors.add(:base, "can only have one CustomFieldValue per CustomField for '#{custom_field.field_type}'")
    end
  end
end
