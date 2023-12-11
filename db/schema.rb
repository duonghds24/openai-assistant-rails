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

ActiveRecord::Schema[7.1].define(version: 20_231_207_062_447) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assistants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "member_id", null: false
    t.string "assistant_id"
    t.string "object"
    t.string "name"
    t.string "description"
    t.string "model", null: false
    t.string "instructions", null: false
    t.text "tools", default: [], array: true
    t.jsonb "metadata", default: {}
    t.integer "sync_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_assistants_on_member_id"
  end

  create_table "members", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "organisation_id", null: false
    t.string "member_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organisation_id"], name: "index_members_on_organisation_id"
  end

  create_table "organisations", id: :uuid, default: lambda {
                                                      "gen_random_uuid()"
                                                    }, force: :cascade do |t|
    t.string "org_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "assistants", "members"
  add_foreign_key "members", "organisations"
end
