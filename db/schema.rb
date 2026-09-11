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

ActiveRecord::Schema[8.1].define(version: 2026_09_11_000013) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "applicant_profiles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "discoverable", default: false, null: false
    t.string "headline"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_applicant_profiles_on_user_id", unique: true
  end

  create_table "applications", force: :cascade do |t|
    t.bigint "applicant_id", null: false
    t.text "cover_note"
    t.datetime "created_at", null: false
    t.bigint "job_posting_id", null: false
    t.integer "stage", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["applicant_id", "job_posting_id"], name: "index_applications_on_applicant_id_and_job_posting_id"
    t.index ["applicant_id"], name: "index_applications_on_applicant_id"
    t.index ["job_posting_id"], name: "index_applications_on_job_posting_id"
    t.index ["stage"], name: "index_applications_on_stage"
  end

  create_table "conversation_participants", force: :cascade do |t|
    t.bigint "conversation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "last_read_at"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["conversation_id", "user_id"], name: "index_conversation_participants_on_conversation_id_and_user_id", unique: true
    t.index ["conversation_id"], name: "index_conversation_participants_on_conversation_id"
    t.index ["user_id"], name: "index_conversation_participants_on_user_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "creator_id", null: false
    t.integer "kind", default: 0, null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_conversations_on_creator_id"
  end

  create_table "interviews", force: :cascade do |t|
    t.bigint "application_id", null: false
    t.datetime "created_at", null: false
    t.integer "duration_minutes", default: 30, null: false
    t.string "location"
    t.string "meeting_link"
    t.integer "mode", default: 0, null: false
    t.text "notes"
    t.datetime "scheduled_at", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "index_interviews_on_application_id", unique: true
    t.index ["scheduled_at"], name: "index_interviews_on_scheduled_at"
  end

  create_table "job_postings", force: :cascade do |t|
    t.integer "compensation_cents"
    t.integer "compensation_period"
    t.datetime "created_at", null: false
    t.text "description", null: false
    t.integer "employment_type", default: 0, null: false
    t.string "location"
    t.bigint "poster_id", null: false
    t.integer "status", default: 0, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.integer "work_arrangement", default: 0, null: false
    t.index ["poster_id"], name: "index_job_postings_on_poster_id"
    t.index ["status", "created_at"], name: "index_job_postings_on_status_and_created_at"
    t.index ["status"], name: "index_job_postings_on_status"
  end

  create_table "messages", force: :cascade do |t|
    t.text "body", null: false
    t.bigint "conversation_id", null: false
    t.datetime "created_at", null: false
    t.bigint "sender_id", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id", "created_at"], name: "index_messages_on_conversation_id_and_created_at"
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "kind", default: 0, null: false
    t.bigint "notifiable_id", null: false
    t.string "notifiable_type", null: false
    t.datetime "read_at"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable"
    t.index ["user_id", "read_at"], name: "index_notifications_on_user_id_and_read_at"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "onboarding_documents", force: :cascade do |t|
    t.bigint "application_id", null: false
    t.bigint "byte_size"
    t.datetime "created_at", null: false
    t.string "file_key"
    t.string "file_name"
    t.string "file_url"
    t.integer "kind", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["application_id", "kind"], name: "index_onboarding_documents_on_application_id_and_kind", unique: true
    t.index ["application_id"], name: "index_onboarding_documents_on_application_id"
  end

  create_table "poster_profiles", force: :cascade do |t|
    t.text "about"
    t.string "company_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_poster_profiles_on_user_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "heard_from"
    t.integer "organization_type", default: 1, null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "applicant_profiles", "users"
  add_foreign_key "applications", "job_postings"
  add_foreign_key "applications", "users", column: "applicant_id"
  add_foreign_key "conversation_participants", "conversations"
  add_foreign_key "conversation_participants", "users"
  add_foreign_key "conversations", "users", column: "creator_id"
  add_foreign_key "interviews", "applications"
  add_foreign_key "job_postings", "users", column: "poster_id"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "notifications", "users"
  add_foreign_key "onboarding_documents", "applications"
  add_foreign_key "poster_profiles", "users"
end
