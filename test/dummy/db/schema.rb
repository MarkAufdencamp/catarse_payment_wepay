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

ActiveRecord::Schema.define(:version => 20161219234432) do

  create_table "catarse_payment_wepay_we_pay_accounts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "proj_id"
    t.string   "account_id"
    t.string   "name"
    t.string   "state"
    t.string   "desc"
    t.string   "owner_user_id"
    t.string   "balances"
    t.string   "statuses"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.index ["account_id"], :name => "index_catarse_payment_wepay_we_pay_accounts_on_account_id"
    t.index ["owner_user_id"], :name => "index_catarse_payment_wepay_we_pay_accounts_on_owner_user_id"
    t.index ["proj_id"], :name => "index_catarse_payment_wepay_we_pay_accounts_on_proj_id"
    t.index ["user_id"], :name => "index_catarse_payment_wepay_we_pay_accounts_on_user_id"
  end

  create_table "catarse_payment_wepay_we_pay_tokens", :force => true do |t|
    t.integer  "user_id"
    t.string   "wepay_user_id"
    t.string   "access_token"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.index ["user_id"], :name => "index_catarse_payment_wepay_we_pay_tokens_on_user_id"
    t.index ["wepay_user_id"], :name => "index_catarse_payment_wepay_we_pay_tokens_on_wepay_user_id"
  end

  create_table "catarse_payment_wepay_we_pay_users", :force => true do |t|
    t.integer  "user_id"
    t.string   "wepay_user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "user_name"
    t.string   "email"
    t.string   "state"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.index ["email"], :name => "index_catarse_payment_wepay_we_pay_users_on_email"
    t.index ["user_id"], :name => "index_catarse_payment_wepay_we_pay_users_on_user_id"
    t.index ["user_name"], :name => "index_catarse_payment_wepay_we_pay_users_on_user_name"
    t.index ["wepay_user_id"], :name => "index_catarse_payment_wepay_we_pay_users_on_wepay_user_id"
  end

end
