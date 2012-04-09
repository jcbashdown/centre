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

ActiveRecord::Schema.define(:version => 20120327210137) do

  create_table "global_link_users", :force => true do |t|
    t.integer  "global_id"
    t.integer  "user_id"
    t.integer  "link_id"
    t.integer  "link_user_id"
    t.integer  "global_link_id"
    t.integer  "node_from_id"
    t.integer  "node_to_id"
    t.integer  "value"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "global_links", :force => true do |t|
    t.integer  "global_id"
    t.integer  "link_id"
    t.integer  "node_from_id"
    t.integer  "node_to_id"
    t.integer  "value"
    t.integer  "global_link_users_count", :default => 0, :null => false
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  create_table "global_node_users", :force => true do |t|
    t.text     "node_xml"
    t.integer  "user_id"
    t.integer  "global_id"
    t.integer  "node_id"
    t.integer  "node_user_id"
    t.integer  "global_node_id"
    t.string   "title"
    t.text     "text"
    t.integer  "global_link_users_count", :default => 0,     :null => false
    t.integer  "equivalents_count",       :default => 0,     :null => false
    t.integer  "upvotes_count",           :default => 0,     :null => false
    t.integer  "downvotes_count",         :default => 0,     :null => false
    t.boolean  "ignore",                  :default => true
    t.boolean  "boolean",                 :default => false
    t.boolean  "is_conclusion",           :default => false
    t.float    "page_rank"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  create_table "global_nodes", :force => true do |t|
    t.text     "node_xml"
    t.integer  "global_id"
    t.integer  "node_id"
    t.string   "title"
    t.text     "text"
    t.integer  "equivalents_count",       :default => 0,     :null => false
    t.integer  "upvotes_count",           :default => 0,     :null => false
    t.integer  "downvotes_count",         :default => 0,     :null => false
    t.boolean  "ignore",                  :default => true
    t.boolean  "boolean",                 :default => false
    t.boolean  "is_conclusion",           :default => false
    t.float    "page_rank"
    t.integer  "global_node_users_count", :default => 0,     :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  create_table "global_users", :id => false, :force => true do |t|
    t.integer "global_id"
    t.integer "user_id"
    t.text    "nodes_xml"
  end

  create_table "globals", :force => true do |t|
    t.string   "name"
    t.text     "nodes_xml"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "link_users", :force => true do |t|
    t.integer  "link_id"
    t.integer  "user_id"
    t.integer  "node_from_id"
    t.integer  "node_to_id"
    t.integer  "value"
    t.integer  "global_link_users_count", :default => 0, :null => false
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  create_table "links", :force => true do |t|
    t.integer  "node_from_id"
    t.integer  "node_to_id"
    t.integer  "global_link_users_count", :default => 0, :null => false
    t.integer  "users_count",             :default => 0, :null => false
    t.integer  "value"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  create_table "node_users", :force => true do |t|
    t.integer  "node_id"
    t.integer  "user_id"
    t.string   "title"
    t.text     "text"
    t.integer  "global_node_users_count", :default => 0,     :null => false
    t.integer  "equivalents_count",       :default => 0,     :null => false
    t.integer  "upvotes_count",           :default => 0,     :null => false
    t.integer  "downvotes_count",         :default => 0,     :null => false
    t.boolean  "ignore",                  :default => true
    t.boolean  "boolean",                 :default => false
    t.boolean  "is_conclusion",           :default => false
    t.float    "page_rank"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  create_table "nodes", :force => true do |t|
    t.string   "title"
    t.text     "text"
    t.integer  "equivalents_count",       :default => 0,     :null => false
    t.integer  "upvotes_count",           :default => 0,     :null => false
    t.integer  "downvotes_count",         :default => 0,     :null => false
    t.boolean  "ignore",                  :default => true
    t.boolean  "boolean",                 :default => false
    t.boolean  "is_conclusion",           :default => false
    t.float    "page_rank"
    t.integer  "global_node_users_count", :default => 0,     :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
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
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.string   "name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
