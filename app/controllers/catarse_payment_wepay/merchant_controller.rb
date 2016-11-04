require 'catarse_payment_wepay/processors'
require 'wepay'

module CatarsePaymentWepay
  class MerchantController < ApplicationController
    skip_before_filter :force_http

    before_filter :setup_gateway

    def index
      # If no merchant account exists and approved projects exist
      # List approved projects and a form button to merchant#setup that then redirects to WePay OAuth account creation
      
      
    end
    
    def setup
      # Redirect to WePay for OAuth based account creation
      client_id = '185853'
      client_secret = 'd1b7d24d45'
      use_stage = true
      
      wepay = WePay::Client.new(client_id, client_secret, use_stage)
      redirect_to( wepay.oauth2_authorize_url(oauth_redirect_uri_url))
    end
    
    def oauth_account_creation
      if params[:code]
        @oauth_code = params[:code]

        client_id = '185853'
        client_secret = 'd1b7d24d45'
        use_stage = true
        
        wepay = WePay::Client.new(client_id, client_secret, use_stage)

        response = wepay.oauth2_token(@oauth_code, oauth_redirect_uri_url)
        access_token = response['access_token']

        response = wepay.call('/user', access_token)
        puts response
        response = wepay.call('/account/create', access_token, {
          :name        => "test account",
          :description => "this is only a test"
        })
        puts response
      else        
        @error_code = params[:error_code]
        @error_description = params[:eror_description]
      end
      
      
    end
        
  private
    def setup_gateway
    end

  end
end
