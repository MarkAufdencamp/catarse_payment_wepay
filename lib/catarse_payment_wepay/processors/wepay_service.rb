module CatarsePaymentWepay
  class WepayService
        
    def self.version
      CatarsePaymentWepay::VERSION
    end
    
    def initialize accessToken
      @token ||= accessToken 
    end
    
    def configure accessToken
      @token = accessToken
    end
    
    def accessToken
      @token
    end
    
  end
end
