require 'catarse_payment_wepay/processors'
require 'wepay'

module CatarsePaymentWepay
  class MerchantController < ApplicationController
    skip_before_filter :force_http

#    before_action :authenticate_user!
    before_filter :factory_wepay_client

    def index
      # params contains user_id, project_id from routed url structure
      #puts params
      if params[:user_id] then @user_id = params[:user_id] end
      if params[:proj_id] then @proj_id = params[:proj_id] end
      puts @user_id
      
      if @user_id
        @we_pay_user = we_pay_user
        @we_pay_token = we_pay_token
        if @we_pay_token
          @access_token = @we_pay_token[:access_token]
        else
          @access_token = nil
        end
      end
      if @user_id && @proj_id
        @we_pay_account = we_pay_account
      end
      
      case
      when !@user_id
        # if Admin
        # TODO: Display paginated WePayUser/WePayToken list with link to WePayUser/WePayAccount list
        # else !Admin
        # TODO: Display No Access
        puts 'index'
        render 'index'
        
      when @user_id && !@proj_id
        # if current_user.id == User_id
        # TODO: Display User_id
        # TODO: Display WePayToken if exists
        # TODO: Display WePayUser if exists
        # TODO: Display WePayAccount's for User_id
        # else
        # TODO: Display No Access
        puts 'user_token_account_info'
        render 'user_token_account_info'
        
      when @user_id && @proj_id && !@access_token
        # if current_user.id == User_id
        # TODO: Display User_id, Project_id
        # TODO: Display user_setup link - wepay_user_setup_path(:user_id => @user_id, :proj_id => @proj_id)
        # else
        # TODO: Display No Access
        puts 'oauth_authentication'
        render 'oauth_authentication'
                
      when @user_id && @proj_id && @access_token && !@we_pay_account
        # if current_user.id == User_id
        # TODO: Display User_id, Project_id
        # TODO: Display WePayToken
        # TODO: Display WePayUser
        # TODO: Display WePayAccount creation link for @user_id, @proj_id - wepay_project_setup_path(:user_id => @user_id, :project_id => @proj_id)
        # else
        # TODO: Display No Access
        puts 'account_creation'
        render 'account_creation'

      when @user_id && @proj_id && @access_token && @we_pay_account
        # if current_user.id == User_id
        # TODO: Display WePayToken
        # TODO: Display WePayUser
        # TODO: Display WePayAccount's for @user_id, @proj_id
        # else
        # TODO: Display No Access
        puts  'account_info'
        render 'account_info'
        
      end
    end
    
    def user_setup
      # params contains user_id, project_id from routed url structure
      # wepay_user_setup_path(:user_id => @user_id, :proj_id => @proj_id)
      #puts params
      @user_id = params[:user_id]
      @proj_id = params[:project_id]
      
      # redirect url from route helper method
      oauth_redirect_uri = wepay_oauth_redirect_url(:user_id => @user_id, :proj_id => @projid)
      oauth_uri =  @wepay.oauth2_authorize_url(oauth_redirect_uri)
      #puts oauth_uri
     
      # Redirect user to WePay OAuth Website
      redirect_to(oauth_uri)
    end
    
    def oauth_account_creation
      # params contains user_id, project_id from routed url structure passed as oauth_redirect_uri in setup
      # params contains either code, or error_code from WePay OAuth Website parameters
      #puts params

      if params[:code]
        @oauth_code = params[:code]
        @user_id = params[:user_id]
        @proj_id = params[:project_id]
      else
        # TODO: Edge guard that error_code, error_description were returned   
        @error_code = params[:error_code]
        @error_description = params[:eror_description]
      end
      
      we_pay_token = CatarsePaymentWepay::WePayToken.where(:user_id => @user_id).first()
      if we_pay_token
        @access_token = we_pay_token[:token]
      else
        create_wepay_token
      end
      
      if @access_token
        create_wepay_user
      end
    end
    
    def account_setup
      @user_id = params[:user_id]
      @proj_id = params[:project_id]
      project_name = params[:name]
      project_desc = params[:desc]
      create_wepay_account project_name, project_desc
    end
        
  private
    def factory_wepay_client
      client_id = CatarsePaymentWepay::WePayConfiguration.credentials[:client_id]
      client_secret = CatarsePaymentWepay::WePayConfiguration.credentials[:client_secret]
      use_stage = CatarsePaymentWepay::WePayConfiguration.use_staging
      @wepay = WePay::Client.new(client_id, client_secret, use_stage)
      
      # TODO: Retrive token from storage and inject as instance variable @access_token
    end
    
    def create_wepay_token
      response = @wepay.oauth2_token(@oauth_code, wepay_oauth_redirect_url(:user_id => @user_id, :proj_id => @proj_id))
      puts response
        
      wepay_user_id = response['user_id']
      access_token = response['access_token']
      token_type = response['token_type']

      if access_token
        @access_token = access_token
        # TODO: Store WePay Token - Test for existance first?
        we_pay_token = CatarsePaymentWepay::WePayToken.create(
          :userId => @user_id,
          :wepayUserId => wepay_user_id,
          :accessToken => access_token)
      else
        # TODO: Edge Guard - Token denial or failure
        we_pay_token = nil
      end
    end

    def create_wepay_user
      response = @wepay.call('/user', @access_token)
      #puts response
      @we_pay_user = CatarsePaymentWepay::WePayUser.create(
        :userId => @user_id,
        :wepayUserId => response[:user_id],
        :firstName => response[:first_name],
        :lastName => response[:last_name],
        :email => response[:email],
        :state => response[:state])        
    end

    def create_wepay_account(project_name, project_desc)
      response = @wepay.call('/account/create', @access_token, {
        :name        => project_name,
        :description => project_desc
      })
      #puts response
      @we_pay_account = CatarsePaymentWepay::WePayAccount.create(
        :accountId => response[:account_id],
        :name => response[:name],
        :state => response[:state],
        :desc => response[:description],
        :ownerUserId => response[:owner_user_id],
        :balances => response[:balances],
        :statuses => response[:statuses],
        :userId => @user_id,
        :projId => @proj_id
      )
    end
    
    def we_pay_token
      we_pay_tokens = CatarsePaymentWepay::WePayToken.find_by_user_id @user_id.to_i
    end
    
    def we_pay_user
      we_pay_user = CatarsePaymentWepay::WePayUser.find_by_user_id @user_id.to_i
    end
     
    def we_pay_account
      we_pay_account = CatarsePaymentWepay::WePayAccount.where(:user_id => @user_id, :proj_id => @proj_id)
    end
     
  end
end
