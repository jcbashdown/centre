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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120311180545) do

  create_table "globals", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "nodes_count", :default => 0
    t.text     "full_text"
  end

  create_table "globals_links", :force => true do |t|
    t.integer  "link_id"
    t.integer  "global_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "users_count", :default => 0, :null => false
  end

  create_table "globals_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "global_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "full_text"
  end

  create_table "links", :force => true do |t|
    t.integer  "node_from_id"
    t.integer  "value"
    t.integer  "node_to_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "users_count",          :default => 0, :null => false
    t.integer  "nodes_global_from_id"
    t.integer  "nodes_global_to_id"
  end

  create_table "nodes", :force => true do |t|
    t.string   "title"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "upvotes_count",     :default => 0,    :null => false
    t.integer  "downvotes_count",   :default => 0,    :null => false
    t.integer  "equivalents_count", :default => 0,    :null => false
    t.boolean  "ignore",            :default => true
    t.float    "page_rank",         :default => 0.0
  end

  create_table "nodes_globals", :force => true do |t|
    t.integer  "node_id"
    t.integer  "global_id"
    t.text     "votes_xml"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_conclusion",     :default => false
    t.integer  "upvotes_count",     :default => 0,     :null => false
    t.integer  "downvotes_count",   :default => 0,     :null => false
    t.integer  "equivalents_count", :default => 0,     :null => false
    t.boolean  "ignore",            :default => true
    t.float    "page_rank",         :default => 0.0
  end

  create_table "user_globals_links", :force => true do |t|
    t.integer  "user_id"
    t.integer  "globals_link_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_links", :force => true do |t|
    t.string   "user_id"
    t.text     "link_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_nodes_globals", :force => true do |t|
    t.text     "votes_xml"
    t.integer  "user_id"
    t.integer  "nodes_global_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
