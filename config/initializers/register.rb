begin
  PaymentEngines.register({
    name: 'Wepay',
    review_path: ->(backer){
      CatarsePaymentWepay::Engine.routes.url_helpers.payment_review_wepay_path(backer)
    },
    locale: 'en'
  })
rescue Exception => e
  puts "Error while registering payment engine: #{e}"
end