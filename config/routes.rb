CatarsePaymentWepay::Engine.routes.draw do
  resources :wepay do
    collection do
      post :ipn
    end

    member do
      post :refund
      get  :review
      post :pay
      get  :success
    end
        
  end

  resources :merchant, path: "merchant" do
      
  end
  
  get 'merchant_setup' => 'merchant#setup'
  post 'merchant_setup/:project_id' => 'merchant#setup'
  get 'oauth_redirect_uri' => 'merchant#oauth_account_creation'
  root to: "merchant#index"
end
