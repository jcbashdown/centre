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

ActiveRecord::Schema.define(:version => 20130303140344) do

  create_table "context_links", :force => true do |t|
    t.integer  "question_id"
    t.integer  "user_id"
    t.integer  "global_link_id"
    t.integer  "user_link_id"
    t.integer  "global_node_from_id"
    t.integer  "global_node_to_id"
    t.integer  "context_node_from_id"
    t.integer  "context_node_to_id"
    t.integer  "question_node_from_id"
    t.integer  "question_node_to_id"
    t.integer  "user_node_from_id"
    t.integer  "user_node_to_id"
    t.boolean  "private",               :default => false
    t.string   "type"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.integer  "group_id"
    t.integer  "group_link_id"
    t.integer  "group_node_from_id"
    t.integer  "group_node_to_id"
    t.integer  "user_node_id"
  end

  add_index "context_links", ["global_link_id"], :name => "index_context_links_on_global_link_id"
  add_index "context_links", ["group_id"], :name => "index_context_links_on_group_id"
  add_index "context_links", ["group_link_id"], :name => "index_context_links_on_group_link_id"
  add_index "context_links", ["group_node_from_id"], :name => "index_context_links_on_group_node_from_id"
  add_index "context_links", ["group_node_to_id"], :name => "index_context_links_on_group_node_to_id"
  add_index "context_links", ["question_id"], :name => "index_context_links_on_question_id"
  add_index "context_links", ["type"], :name => "index_context_links_on_type"
  add_index "context_links", ["user_id"], :name => "index_context_links_on_user_id"
  add_index "context_links", ["user_link_id"], :name => "index_context_links_on_user_link_id"
  add_index "context_links", ["user_node_id"], :name => "index_context_links_on_user_node_id"

  create_table "context_nodes", :force => true do |t|
    t.integer  "question_id"
    t.integer  "user_id"
    t.text     "title"
    t.integer  "user_node_id"
    t.integer  "question_node_id"
    t.integer  "private_global_node_id"
    t.integer  "private_user_node_id"
    t.integer  "private_question_node_id"
    t.integer  "node_title_id"
    t.boolean  "is_conclusion"
    t.boolean  "private",                  :default => false
    t.boolean  "direct_creation",          :default => false
    t.integer  "context_links_count",      :default => 0,     :null => false
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.integer  "group_id"
    t.integer  "group_node_id"
  end

  add_index "context_nodes", ["group_id"], :name => "index_context_nodes_on_group_id"
  add_index "context_nodes", ["group_node_id"], :name => "index_context_nodes_on_group_node_id"
  add_index "context_nodes", ["node_title_id"], :name => "index_context_nodes_on_node_title_id"
  add_index "context_nodes", ["question_id"], :name => "index_context_nodes_on_question_id"
  add_index "context_nodes", ["question_node_id"], :name => "index_context_nodes_on_question_node_id"
  add_index "context_nodes", ["user_id"], :name => "index_context_nodes_on_user_id"
  add_index "context_nodes", ["user_node_id"], :name => "index_context_nodes_on_user_node_id"

  create_table "group_question_conclusions", :force => true do |t|
    t.integer  "group_id"
    t.integer  "question_id"
    t.integer  "global_node_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "groups", :force => true do |t|
    t.string   "title"
    t.text     "about"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "links", :force => true do |t|
    t.integer  "user_id"
    t.integer  "global_link_id"
    t.integer  "global_node_from_id"
    t.integer  "global_node_to_id"
    t.integer  "users_count",         :default => 0,     :null => false
    t.boolean  "active",              :default => false
    t.boolean  "private",             :default => false
    t.string   "type"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "group_id"
  end

  add_index "links", ["active"], :name => "index_links_on_active"
  add_index "links", ["global_link_id"], :name => "index_links_on_global_link_id"
  add_index "links", ["global_node_from_id"], :name => "index_links_on_global_node_from_id"
  add_index "links", ["global_node_to_id"], :name => "index_links_on_global_node_to_id"
  add_index "links", ["group_id"], :name => "index_links_on_group_id"
  add_index "links", ["type"], :name => "index_links_on_type"
  add_index "links", ["user_id"], :name => "index_links_on_user_id"

  create_table "node_bodies", :force => true do |t|
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "nodes", :force => true do |t|
    t.integer  "global_node_id"
    t.integer  "user_id"
    t.integer  "question_id"
    t.text     "title"
    t.integer  "equivalents_count",          :default => 0,     :null => false
    t.integer  "upvotes_count",              :default => 0,     :null => false
    t.integer  "downvotes_count",            :default => 0,     :null => false
    t.integer  "related_votes_count",        :default => 0,     :null => false
    t.integer  "part_of_votes_count",        :default => 0,     :null => false
    t.integer  "conclusion_votes_count",     :default => 0,     :null => false
    t.boolean  "is_conclusion"
    t.float    "page_rank",                  :default => 0.0
    t.integer  "users_count",                :default => 0,     :null => false
    t.boolean  "private",                    :default => false
    t.string   "type"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.integer  "not_conclusion_votes_count", :default => 0,     :null => false
    t.integer  "group_id"
  end

  add_index "nodes", ["group_id"], :name => "index_nodes_on_group_id"
  add_index "nodes", ["question_id"], :name => "index_nodes_on_question_id"
  add_index "nodes", ["type"], :name => "index_nodes_on_type"
  add_index "nodes", ["user_id"], :name => "index_nodes_on_user_id"

  create_table "question_conclusions", :force => true do |t|
    t.integer  "question_id"
    t.integer  "global_node_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "question_users", :force => true do |t|
    t.integer "question_id"
    t.integer "user_id"
  end

  add_index "question_users", ["question_id"], :name => "index_question_users_on_question_id"
  add_index "question_users", ["user_id"], :name => "index_question_users_on_user_id"

  create_table "questions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_groups", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_nodes", :force => true do |t|
    t.integer  "global_node_id"
    t.integer  "user_id"
    t.text     "title"
    t.integer  "equivalents_count",      :default => 0,     :null => false
    t.integer  "upvotes_count",          :default => 0,     :null => false
    t.integer  "downvotes_count",        :default => 0,     :null => false
    t.integer  "related_votes_count",    :default => 0,     :null => false
    t.integer  "part_of_votes_count",    :default => 0,     :null => false
    t.integer  "conclusion_votes_count", :default => 0,     :null => false
    t.boolean  "is_conclusion",          :default => false
    t.float    "page_rank",              :default => 0.0
    t.integer  "users_count",            :default => 0,     :null => false
    t.boolean  "private",                :default => false
    t.string   "type"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "user_nodes", ["type"], :name => "index_user_nodes_on_type"
  add_index "user_nodes", ["user_id"], :name => "index_user_nodes_on_user_id"

  create_table "user_question_conclusions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "question_id"
    t.integer  "global_node_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
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
