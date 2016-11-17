module CatarsePaymentWepay
  class WePayToken < ActiveRecord::Base
    attr_accessible :token, :userId
  end
end
