module CatarsePaymentWepay
  class WePayUser < ActiveRecord::Base
    attr_accessible :user_id, :wepay_user_id, :first_name, :lasy_name, :email, :state
  end
end
