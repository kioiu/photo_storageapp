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

ActiveRecord::Schema[7.2].define(version: 2026_06_23_010348) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "photo_sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "title"
    t.datetime "started_at"
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "classification"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_photo_sessions_on_user_id"
  end

  create_table "photos", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "photo_session_id", null: false
    t.string "title"
    t.datetime "captured_at"
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "camera"
    t.string "lens"
    t.integer "iso"
    t.string "aperture"
    t.string "shutter_speed"
    t.string "focal_length"
    t.boolean "has_gps"
    t.json "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["photo_session_id"], name: "index_photos_on_photo_session_id"
    t.index ["user_id"], name: "index_photos_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.boolean "guest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "folder_distance_km", precision: 5, scale: 2, default: "3.0", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "photo_sessions", "users"
  add_foreign_key "photos", "photo_sessions"
  add_foreign_key "photos", "users"
end
