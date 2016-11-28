# This migration comes from catarse_payment_wepay (originally 20161121151727)
class CreateWePayAccounts < ActiveRecord::Migration
  def up
    create_table :catarse_payment_wepay_we_pay_accounts do |t|
      t.integer :user_id
      t.integer :proj_id
      t.string :account_id    
      t.string :name
      t.string :state
      t.string :desc
      t.string :owner_user_id
      t.string :balances
      t.string :statuses

      t.timestamps
    end
    add_index :catarse_payment_wepay_we_pay_accounts, :user_id
    add_index :catarse_payment_wepay_we_pay_accounts, :proj_id
    add_index :catarse_payment_wepay_we_pay_accounts, :owner_user_id
    add_index :catarse_payment_wepay_we_pay_accounts, :account_id
  end

  def down
  end
end
