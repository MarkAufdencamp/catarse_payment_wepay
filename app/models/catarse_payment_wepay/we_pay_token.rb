module CatarsePaymentWepay
  class WePayToken < ActiveRecord::Base
    # TODO: Encrypt WePayToken.access_token
    attr_accessible :user_id, :wepay_user_id, :access_token
  end
end
