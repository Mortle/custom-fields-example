require 'rails_helper'

RSpec.describe V1::UsersController, type: :request do
  describe 'PATCH /update' do
    let(:user) { FactoryBot.create(:user) }
    let(:text_field) { FactoryBot.create(:custom_field, name: 'Bio', field_type: 'text') }
    let(:number_field) { FactoryBot.create(:custom_field, name: 'Age', field_type: 'number') }
    let(:single_select_field) { FactoryBot.create(:custom_field, name: 'Gender', field_type: 'single_select') }
    let(:multiple_select_field) { FactoryBot.create(:custom_field, name: 'Favorite Music', field_type: 'multiple_select') }

    before do
      single_select_field.custom_field_options.create!(value: 'Male')
      single_select_field.custom_field_options.create!(value: 'Female')

      multiple_select_field.custom_field_options.create!(value: 'The Beatles')
      multiple_select_field.custom_field_options.create!(value: 'The Doors')
      multiple_select_field.custom_field_options.create!(value: 'The Who')

      patch v1_user_path(user), params: request_params
    end

    context 'when creating invalid custom field values' do
      let(:request_params) {
        {
          user: {
            custom_field_values_attributes: [
              { custom_field_id: text_field.id, value: nil },
              { custom_field_id: number_field.id, value: '$10' },
              { custom_field_id: single_select_field.id, value: 'Combat Helicopter Mi-24' },
              { custom_field_id: multiple_select_field.id, value: 'The Beatles' },
              { custom_field_id: multiple_select_field.id, value: 'Moonlight Sorcery' },
            ]
          }
        }
      }

      it 'does not create the user custom field values' do
        user.reload
        expect(user.custom_field_values.count).to eq(0)
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        error_messages = JSON.parse(response.body)['errors']
        expect(error_messages.sort).to eq([
          "Custom field values value can't be blank", # text error
          "Custom field values value is not included in the list of options", # single and multi select errors
          "Custom field values value must be a valid number" # number error
        ])
      end
    end

    context 'when creating valid custom field values' do
      let(:request_params) {
        {
          user: {
            custom_field_values_attributes: [
              { custom_field_id: text_field.id, value: "This is a bio." },
              { custom_field_id: number_field.id, value: 30 },
              { custom_field_id: single_select_field.id, value: 'Male' },
              { custom_field_id: multiple_select_field.id, value: 'The Beatles' },
              { custom_field_id: multiple_select_field.id, value: 'The Doors' },
            ]
          }
        }
      }

      it 'creates the user custom field values' do
        user.reload
        expect(user.custom_field_values.count).to eq(5)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when updating custom field values' do
      let(:custom_field_value) { FactoryBot.create(:custom_field_value, custom_field: text_field, fieldable: user, value: 'Old bio.') }

      let(:request_params) {
        {
          user: {
            custom_field_values_attributes: [
              { id: custom_field_value.id, value: "This is a new bio." },
            ]
          }
        }
      }

      it 'updates the user custom field value' do
        custom_field_value.reload
        expect(custom_field_value.value).to eq('This is a new bio.')
      end
    end

    context 'when destroying custom field values' do
      let!(:custom_field_value) { FactoryBot.create(:custom_field_value, custom_field: text_field, fieldable: user, value: 'Old bio.') }

      let(:request_params) {
        {
          user: {
            custom_field_values_attributes: [
              { id: custom_field_value.id, _destroy: true },
            ]
          }
        }
      }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'destroys the user custom field value' do
        expect { custom_field_value.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
