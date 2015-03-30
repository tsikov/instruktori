# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150316141209) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "exams", force: :cascade do |t|
    t.integer  "protocol"
    t.date     "date"
    t.string   "examiner"
    t.integer  "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "instructors", force: :cascade do |t|
    t.string   "name"
    t.string   "city"
    t.string   "address"
    t.string   "phone"
    t.string   "categories",              array: true
    t.string   "province"
    t.integer  "permit"
    t.float    "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "results", force: :cascade do |t|
    t.integer  "exam_id"
    t.integer  "instructor_id"
    t.integer  "result"
    t.string   "student_name"
    t.string   "notes"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "results", ["exam_id"], name: "index_results_on_exam_id", using: :btree
  add_index "results", ["instructor_id"], name: "index_results_on_instructor_id", using: :btree

  add_foreign_key "results", "exams"
  add_foreign_key "results", "instructors"
end
