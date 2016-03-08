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

ActiveRecord::Schema.define(version: 20160307110505) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artistpages", force: :cascade do |t|
    t.string   "letterstart"
    t.string   "letterend"
    t.string   "title"
    t.integer  "seq"
    t.integer  "festival_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "artistpages", ["festival_id"], name: "index_artistpages_on_festival_id", using: :btree

  create_table "artists", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.string   "linkid"
    t.boolean  "active",      default: false
    t.date     "extractdate"
    t.integer  "festival_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "artists", ["festival_id"], name: "index_artists_on_festival_id", using: :btree

  create_table "festivals", force: :cascade do |t|
    t.date     "startdate"
    t.integer  "days"
    t.date     "scheduledate"
    t.string   "year"
    t.string   "title"
    t.integer  "major"
    t.integer  "minor"
    t.boolean  "active"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "performances", force: :cascade do |t|
    t.integer  "daynumber"
    t.string   "duration"
    t.time     "starttime"
    t.string   "title"
    t.string   "scheduleversion"
    t.integer  "festival_id"
    t.integer  "artist_id"
    t.integer  "stage_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "performances", ["artist_id"], name: "index_performances_on_artist_id", using: :btree
  add_index "performances", ["festival_id"], name: "index_performances_on_festival_id", using: :btree
  add_index "performances", ["stage_id"], name: "index_performances_on_stage_id", using: :btree

  create_table "stages", force: :cascade do |t|
    t.string   "title"
    t.string   "code",        limit: 2
    t.integer  "seq"
    t.integer  "festival_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "stages", ["festival_id"], name: "index_stages_on_festival_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "screen_name"
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin"
    t.boolean  "tester"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_foreign_key "artistpages", "festivals"
  add_foreign_key "artists", "festivals"
  add_foreign_key "performances", "artists"
  add_foreign_key "performances", "festivals"
  add_foreign_key "performances", "stages"
  add_foreign_key "stages", "festivals"
end
