Rails.application.routes.draw do

  mount CatarsePaymentWepay::Engine => "/catarse_payment_wepay"
end
