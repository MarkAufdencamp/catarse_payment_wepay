module CatarsePaymentWepay
  class WePayConfiguration
    @credentials = {}
    @staging = true
    
    def self.set_credentials(client_id, client_secret)
      @credentials = {
        :client_id => client_id,
        :client_secret => client_secret
      }
    end
        
    def self.credentials
      @credentials
    end
    
    def self.use_staging
      return @staging
    end
    
    def self.set_staging staging
      @staging = staging
    end
  end
end

begin
  # PaymentEngines exist from parent Catarse based application
  PaymentEngines.register({
    name: 'Wepay',
    review_path: ->(backer){
      CatarsePaymentWepay::Engine.routes.url_helpers.payment_review_wepay_path(backer)
    },
    locale: 'en'
  })
  # TODO: Edge guard WePay Client Id, Secret retrieval.  Notify Admin when Gem Loaded/Mounted and Configuration missing.
  WEPAY_CLIENT_ID = PaymentEngines.configuration.where(:name => 'wepay_client_id').first[:value]
  WEPAY_CLIENT_SECRET = PaymentEngines.configuration.where(:name => 'wepay_client_secret').first[:value]
  puts WEPAY_CLIENT_ID
  puts WEPAY_CLIENT_SECRET
  if Rails.env.development? || Rails.env.test?
    CatarsePaymentWepay::WePayConfiguration.set_staging(true)
  else
    CatarsePaymentWepay::WePayConfiguration.set_staging(false)
  end
rescue Exception => e
  # PaymentEngines does NOT exist from parent Catarse based application
  puts "Error while registering payment engine: #{e}"
  WEPAY_CLIENT_ID = '185853'
  WEPAY_CLIENT_SECRET = 'd1b7d24d45'
  CatarsePaymentWepay::WePayConfiguration.set_staging(true)
end
puts 'CatarsePaymentWepay Registered'
CatarsePaymentWepay::WePayConfiguration.set_credentials(WEPAY_CLIENT_ID, WEPAY_CLIENT_SECRET)
