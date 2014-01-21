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

ActiveRecord::Schema.define(version: 20140121092406) do

  create_table "bell_cycle_periods", force: true do |t|
    t.time     "start_time"
    t.time     "end_time"
    t.integer  "bell_cycle_id"
    t.integer  "period_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bell_cycle_periods", ["bell_cycle_id"], name: "index_bell_cycle_periods_on_bell_cycle_id"
  add_index "bell_cycle_periods", ["period_id"], name: "index_bell_cycle_periods_on_period_id"

  create_table "bell_cycles", force: true do |t|
    t.integer  "bell_id"
    t.integer  "cycle_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bell_cycles", ["bell_id"], name: "index_bell_cycles_on_bell_id"
  add_index "bell_cycles", ["cycle_id"], name: "index_bell_cycles_on_cycle_id"

  create_table "bells", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cycles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "periods", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "school_days", force: true do |t|
    t.date     "day"
    t.integer  "bell_cycle_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "school_days", ["bell_cycle_id"], name: "index_school_days_on_bell_cycle_id"

end
