class CreateCatarsePaymentWepayWePayTokens < ActiveRecord::Migration
  def change
    create_table :catarse_payment_wepay_we_pay_tokens do |t|
      t.string :userId
      t.string :token

      t.timestamps
    end
    add_index :catarse_payment_wepay_we_pay_tokens, :token
  end
end
