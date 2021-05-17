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

ActiveRecord::Schema.define(version: 2021_02_01_000010) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "plpgsql"

  create_table "components_file_contents", id: false, force: :cascade do |t|
    t.uuid "component_id", null: false
    t.bigint "file_content_id", null: false
    t.index ["component_id", "file_content_id"], name: "index_components_file_contents", unique: true
  end

  create_table "file_contents", force: :cascade do |t|
    t.binary "sha", null: false
    t.binary "sha_clean"
    t.index ["sha", "sha_clean"], name: "index_file_contents_on_sha_and_sha_clean", unique: true
    t.index ["sha_clean"], name: "index_file_contents_on_sha_clean", where: "(sha_clean IS NOT NULL)"
  end

  create_table "file_licenses", id: false, force: :cascade do |t|
    t.uuid "component_id", null: false
    t.json "license", null: false
    t.text "path", null: false
    t.bigint "file_content_id", null: false
    t.index ["component_id", "path", "file_content_id"], name: "index_file_licenses_composite"
    t.index ["file_content_id"], name: "index_file_licenses_on_file_content_id"
  end

  create_table "files", id: false, force: :cascade do |t|
    t.uuid "component_id", null: false
    t.text "file_path", null: false
    t.binary "fingerprint_sha_256", null: false
    t.binary "fingerprint_comment_stripped_sha_256"
    t.json "license_info"
    t.index ["component_id", "file_path"], name: "index_files_on_component_id_and_file_path", unique: true
    t.index ["component_id"], name: "index_files_on_component_id", where: "(license_info IS NOT NULL)"
    t.index ["fingerprint_comment_stripped_sha_256"], name: "index_files_on_fingerprint_comment_stripped_sha_256", where: "(fingerprint_comment_stripped_sha_256 IS NOT NULL)"
    t.index ["fingerprint_sha_256"], name: "index_files_on_fingerprint_sha_256"
  end

  add_foreign_key "components_file_contents", "file_contents"
  add_foreign_key "file_licenses", "file_contents"
end
