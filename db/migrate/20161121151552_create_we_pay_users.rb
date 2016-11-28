class CreateWePayUsers < ActiveRecord::Migration
  def up
    create_table :catarse_payment_wepay_we_pay_users do |t|
      t.integer :user_id
      t.string :wepay_user_id
      t.string :first_name
      t.string :last_name
      t.string :user_name
      t.string :email
      t.string :state
      
      t.timestamps
    end
    add_index :catarse_payment_wepay_we_pay_users, :user_id
    add_index :catarse_payment_wepay_we_pay_users, :wepay_user_id
    add_index :catarse_payment_wepay_we_pay_users, :user_name
    add_index :catarse_payment_wepay_we_pay_users, :email
  end
  
  def down
    
  end
end
