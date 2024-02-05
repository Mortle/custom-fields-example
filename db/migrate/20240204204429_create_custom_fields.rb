class CreateCustomFields < ActiveRecord::Migration[7.0]
  def change
    create_table :custom_fields do |t|
      t.string :name, null: false
      t.integer :field_type, null: false, limit: 3

      t.timestamps
    end
  end
end
