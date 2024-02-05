class CreateCustomFieldValues < ActiveRecord::Migration[7.0]
  def change
    create_table :custom_field_values do |t|
      t.references :custom_field, null: false, foreign_key: true

      t.bigint :fieldable_id, null: false
      t.string :fieldable_type, null: false

      t.text :value

      t.timestamps
    end

    add_index :custom_field_values, [:fieldable_type, :fieldable_id]
  end
end
