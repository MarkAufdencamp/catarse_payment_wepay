CatarsePaymentWepay::Engine.routes.draw do
  #resources :wepay do
    #collection do
    #  post :ipn
    #end

    #member do
    #  post :refund
    #  get  :review
    #  post :pay
    #  get  :success
    #end
        
  #end

  #resources :merchant, path: "merchant" do
      
  #end
  
  get 'user_setup/:user_id/:proj_id' => 'merchant#user_setup', as: 'wepay_user_setup'
  get 'wepay_oauth_redirect/:user_id/:proj_id' => 'merchant#oauth_account_creation', as: 'wepay_oauth_redirect'
  get 'account_setup/:user_id/:proj_id' => 'merchant#account_setup', as: 'wepay_account_setup'
  get 'account_refresh/:user_id/:proj_id' => 'merchant#account_refresh', as: 'wepay_account_refresh'

  get ':user_id/:proj_id' => "merchant#index", as: 'wepay_account_info'
  get ':user_id' => "merchant#index", as: 'wepay_user_info'
  get '/' => 'merchant#index', as: 'wepay_root'
end
