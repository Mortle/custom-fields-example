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
require 'rails_helper'

RSpec.describe CustomFieldValue, type: :model do
  describe 'validations' do
    let(:fieldable) { FactoryBot.create(:user) }
    let(:custom_field) { FactoryBot.create(:custom_field, field_type: field_type) }

    context 'when field_type is multiple_select' do
      let(:field_type) { 'multiple_select' }
      let(:allowed_value1) { 'Option 1' }
      let(:allowed_value2) { 'Option 2' }
      let(:disallowed_value) { 'Option 3' }

      before do
        FactoryBot.create(:custom_field_option, custom_field: custom_field, value: allowed_value1)
        FactoryBot.create(:custom_field_option, custom_field: custom_field, value: allowed_value2)
      end

      context 'when value is duplicated among custom_field_values' do
        let!(:existing_custom_field_value) { FactoryBot.create(:custom_field_value, fieldable: fieldable, custom_field: custom_field, value: allowed_value1) }
        let(:custom_field_value) { FactoryBot.build(:custom_field_value, fieldable: fieldable, custom_field: custom_field, value: allowed_value1) }

        it 'is not valid' do
          expect(custom_field_value).not_to be_valid
          expect(custom_field_value.errors[:value]).to eq(["already exists in the list of CustomFieldValue's"])
        end
      end

      context 'when value is not included in the list of options' do
        let(:custom_field_value) { FactoryBot.build(:custom_field_value, custom_field: custom_field, value: disallowed_value) }

        it 'is not valid' do
          expect(custom_field_value).not_to be_valid
          expect(custom_field_value.errors[:value]).to eq(["is not included in the list of options"])
        end
      end

      context 'when other custom_field_values exist' do
        let!(:existing_custom_field_value) { FactoryBot.create(:custom_field_value, fieldable: fieldable, custom_field: custom_field, value: allowed_value1) }
        let(:custom_field_value) { FactoryBot.build(:custom_field_value, fieldable: fieldable, custom_field: custom_field, value: allowed_value2) }

        it 'is valid' do
          expect(custom_field_value).to be_valid
        end
      end
    end

    context 'when field_type is single_select' do
      let(:field_type) { 'single_select' }
      let(:value) { "Test text" }

      before do
        FactoryBot.create(:custom_field_option, custom_field: custom_field, value: value)
      end

      context 'when value is not included in the list of options' do
        let(:custom_field_value) { FactoryBot.build(:custom_field_value, custom_field: custom_field, value: '@') }

        it 'is not valid' do
          expect(custom_field_value).not_to be_valid
          expect(custom_field_value.errors[:value]).to eq(["is not included in the list of options"])
        end
      end

      context 'when other custom_field_values exist' do
        let!(:existing_custom_field_value) { FactoryBot.create(:custom_field_value, fieldable: fieldable, custom_field: custom_field, value: value) }
        let(:custom_field_value) { FactoryBot.build(:custom_field_value, fieldable: fieldable, custom_field: custom_field, value: value) }

        it 'is not valid' do
          expect(custom_field_value).not_to be_valid
          expect(custom_field_value.errors[:base]).to eq(["can only have one CustomFieldValue per CustomField for '#{field_type}'"])
        end
      end

      context 'when no other custom_field_values exist' do
        let(:custom_field_value) { FactoryBot.build(:custom_field_value, custom_field: custom_field, value: value) }

        it 'is valid' do
          expect(custom_field_value).to be_valid
        end
      end
    end

    context 'when field_type is text' do
      let(:field_type) { 'text' }
      let(:value) { "Test text" }

      context 'when other custom_field_values exist' do
        let!(:existing_custom_field_value) { FactoryBot.create(:custom_field_value, fieldable: fieldable, custom_field: custom_field, value: value) }
        let(:custom_field_value) { FactoryBot.build(:custom_field_value, fieldable: fieldable, custom_field: custom_field, value: value) }

        it 'is not valid' do
          expect(custom_field_value).not_to be_valid
          expect(custom_field_value.errors[:base]).to eq(["can only have one CustomFieldValue per CustomField for '#{field_type}'"])
        end
      end

      context 'when no other custom_field_values exist' do
        let(:custom_field_value) { FactoryBot.build(:custom_field_value, custom_field: custom_field, value: value) }

        it 'is valid' do
          expect(custom_field_value).to be_valid
        end
      end
    end

    context 'when field_type is number' do
      let(:field_type) { 'number' }
      let(:value) { 4.12 }

      context 'when other custom_field_values exist' do
        let!(:existing_custom_field_value) { FactoryBot.create(:custom_field_value, fieldable: fieldable, custom_field: custom_field, value: value) }
        let(:custom_field_value) { FactoryBot.build(:custom_field_value, fieldable: fieldable, custom_field: custom_field, value: value) }

        it 'is not valid' do
          expect(custom_field_value).not_to be_valid
          expect(custom_field_value.errors[:base]).to eq(["can only have one CustomFieldValue per CustomField for '#{field_type}'"])
        end
      end

      context 'when no other custom_field_values exist' do
        let(:custom_field_value) { FactoryBot.build(:custom_field_value, custom_field: custom_field, value: value) }

        it 'is valid' do
          expect(custom_field_value).to be_valid
        end
      end

      context 'when value is not a valid number' do
        let(:invalid_value) { "Test text" }
        let(:custom_field_value) { FactoryBot.build(:custom_field_value, custom_field: custom_field, value: invalid_value) }

        it 'is not valid' do
          expect(custom_field_value).not_to be_valid
          expect(custom_field_value.errors[:value]).to eq(["must be a valid number"])
        end
      end
    end
  end
end
