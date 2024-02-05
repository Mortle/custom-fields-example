# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_02_04_212733) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "custom_field_options", force: :cascade do |t|
    t.bigint "custom_field_id", null: false
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["custom_field_id"], name: "index_custom_field_options_on_custom_field_id"
  end

  create_table "custom_field_values", force: :cascade do |t|
    t.bigint "custom_field_id", null: false
    t.bigint "fieldable_id", null: false
    t.string "fieldable_type", null: false
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["custom_field_id"], name: "index_custom_field_values_on_custom_field_id"
    t.index ["fieldable_type", "fieldable_id"], name: "index_custom_field_values_on_fieldable_type_and_fieldable_id"
  end

  create_table "custom_fields", force: :cascade do |t|
    t.string "name", null: false
    t.integer "field_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "custom_field_options", "custom_fields"
  add_foreign_key "custom_field_values", "custom_fields"
end
