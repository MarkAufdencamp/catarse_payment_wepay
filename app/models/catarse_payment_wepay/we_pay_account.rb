module CatarsePaymentWepay
  class WePayAccount < ActiveRecord::Base
    attr_accessible :user_id, :proj_id, :account_id, :name, :state, :desc, :owner_user_id, :balances, :statuses
    serialize :balances, JSON
    serialize :statuses, JSON
  end
end
