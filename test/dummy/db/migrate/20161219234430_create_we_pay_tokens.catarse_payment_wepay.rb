# This migration comes from catarse_payment_wepay (originally 20161104203736)
class CreateWePayTokens < ActiveRecord::Migration
  def up
    create_table :catarse_payment_wepay_we_pay_tokens do |t|
      t.integer :user_id, foreign_key: false
      t.string :wepay_user_id, foreign_key: false
      t.string :access_token
    
      t.timestamps
    end
    
    add_index :catarse_payment_wepay_we_pay_tokens, :user_id
    add_index :catarse_payment_wepay_we_pay_tokens, :wepay_user_id
  end
  
  def down
    drop_table :catarse_payment_wepay_we_pay_tokens
  end
end
