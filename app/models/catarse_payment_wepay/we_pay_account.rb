module CatarsePaymentWepay
  class WePayAccount < ActiveRecord::Base
    attr_accessible :user_id, :proj_id, :account_id, :name, :desc, :owner_user_id, :balances, :statuses
  end
end
