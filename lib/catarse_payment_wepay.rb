require "catarse_payment_wepay/engine"

module CatarsePaymentWepay
  module Processors
    
  end
  
  def project_account(proj_id)
    we_pay_account = CatarsePaymentWepay::WePayAccount.find_by_proj_id proj_id
    we_pay_account.account_id
  end
  
  def project_balances(proj_id)
    we_pay_account = CatarsePaymentWepay::WePayAccount.find_by_proj_id proj_id
    we_pay_account.balances
  end
  
  def wepay_name(user_id)
    we_pay_user = CatarsePaymentWepay::WePayUser.find_by_user_id user_id
    we_pay_user.user_name
  end

  def wepay_id(user_id)
    we_pay_user = CatarsePaymentWepay::WePayUser.find_by_user_id user_id
    we_pay_user.wepay_user_id
  end
  
end
