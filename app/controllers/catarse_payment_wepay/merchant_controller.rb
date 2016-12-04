require 'catarse_payment_wepay/processors'
require 'wepay'

module CatarsePaymentWepay
  class MerchantController < ApplicationController
    skip_before_filter :force_http

#    before_action :authenticate_user!
    before_filter :factory_wepay_client

    #before_action :authenticate_user!

    def index
      # params contains user_id, project_id from routed url structure
      #puts params
      if params[:user_id] then @user_id = params[:user_id] end
      if params[:proj_id] then @proj_id = params[:proj_id] end
      #puts @user_id
      #puts @proj_id
      
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
        @we_pay_users = CatarsePaymentWepay::WePayUser.paginate(:page => params[:page], :per_page => 25)
        # else !Admin
        # TODO: Display No Access
        #puts 'index'
        render 'user_list'
        
      when @user_id && !@proj_id
        # if current_user.id == User_id
        # TODO: Display User_id
        # TODO: Display WePayToken if exists
        # TODO: Display WePayUser if exists
        # TODO: Display WePayAccount's for User_id
        puts @access_token, @user_id
        if @we_pay_user
          @we_pay_accounts = CatarsePaymentWepay::WePayAccount.where(:user_id => @user_id).paginate(:page => params[:page], :per_page => 10)
          render 'user_token_account_info'
        else
          render 'invalid_user'
        end
        # else
        # TODO: Display No Access
        #puts 'user_token_account_info'
        
      when @user_id && @proj_id && !@access_token
        # if current_user.id == User_id
        # TODO: Display User_id, Project_id
        # TODO: Display user_setup link - wepay_user_setup_path(:user_id => @user_id, :proj_id => @proj_id)
        # else
        # TODO: Display No Access
        #puts 'oauth_authentication'
        render 'oauth_authentication'
                
      when @user_id && @proj_id && @access_token && !@we_pay_account
        # if current_user.id == User_id
        # TODO: Display User_id, Project_id
        # TODO: Display WePayToken
        # TODO: Display WePayUser
        # TODO: Display WePayAccount creation link for @user_id, @proj_id - wepay_project_setup_path(:user_id => @user_id, :project_id => @proj_id)
        # else
        # TODO: Display No Access
        #puts 'account_creation'
        render 'account_creation'

      when @user_id && @proj_id && @access_token && @we_pay_account
        # if current_user.id == User_id
        # TODO: Display WePayToken
        # TODO: Display WePayUser
        # TODO: Display WePayAccount's for @user_id, @proj_id
        # else
        # TODO: Display No Access
        #puts  'account_info'
        render 'account_info'
        
      end
    end
    
    def user_setup
      # params contains user_id, project_id from routed url structure
      # wepay_user_setup_path(:user_id => @user_id, :proj_id => @proj_id)
      #puts params
      @user_id = params[:user_id]
      @proj_id = params[:proj_id]
      
      # redirect url from route helper method
      oauth_redirect_uri = wepay_oauth_redirect_url(:user_id => @user_id, :proj_id => @proj_id)
      #puts oauth_redirect_uri
      oauth_uri =  @wepay.oauth2_authorize_url(oauth_redirect_uri)
      #puts oauth_uri
     
      # Redirect user to WePay OAuth Website
      redirect_to(oauth_uri)
    end
    
    def oauth_account_creation
      # params contains user_id, project_id from routed url structure passed as oauth_redirect_uri in setup
      # params contains either code, or error_code from WePay OAuth Website parameters
      #puts params

      if params[:code] && params[:user_id] && params[:proj_id]
        @oauth_code = params[:code]
        @user_id = params[:user_id]
        @proj_id = params[:proj_id]

        @we_pay_token = we_pay_token
        if @we_pay_token
          @access_token = we_pay_token[:access_token]
        else
          create_wepay_token
        end
        
        if @access_token
          create_wepay_user
        end
        render 'oauth_success'
      else
        # TODO: Edge guard that error_code, error_description were returned   
        @error_code = params[:error_code]
        @error_description = params[:eror_description]
        render 'oauth_failure'
      end
      
    end
    
    def account_setup
      @user_id = params[:user_id]
      @proj_id = params[:proj_id]
      project_name = params[:name]
      project_desc = params[:desc]

      @we_pay_token = we_pay_token
      if @we_pay_token
        @access_token = we_pay_token[:access_token]
      end

      if @access_token
        create_wepay_account project_name, project_desc
        render 'account_creation_success'
      else
        render 'account_creation_failure'
      end
    end
    
    def account_refresh
      @user_id = params[:user_id]
      @proj_id = params[:proj_id]
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
      if @user_id && @proj_id && @we_pay_user && @we_pay_token &&  @access_token  && @we_pay_account
        refresh_wepay_account
        render 'account_info'
      else
        
      end
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
          :user_id => @user_id,
          :wepay_user_id => wepay_user_id,
          :access_token => access_token)
      else
        # TODO: Edge Guard - Token denial or failure
        we_pay_token = nil
      end
    end

    def create_wepay_user
      response = @wepay.call('/user', @access_token)
      puts response

      wepay_user_id = response['user_id']
      first_name = response['first_name']
      last_name = response['last_name']
      user_name = response['user_name']
      email = response['email']
      state = response['state']
      
      @we_pay_user = CatarsePaymentWepay::WePayUser.create(
        :user_id => @user_id,
        :wepay_user_id => wepay_user_id,
        :first_name => first_name,
        :last_name => last_name,
        :user_name => user_name,
        :email => email,
        :state => state)        
    end

    def create_wepay_account(project_name, project_desc)
      response = @wepay.call('/account/create', @access_token, {
        :name        => project_name,
        :description => project_desc
      })
      puts response
      account_id = response['account_id']
      name = response['name']
      state = response['state']
      desc = response['description']
      owner_user_id = response['owner_user_id']
      balances = response['balances']
      statuses = response['statuses']
      
      @we_pay_account = CatarsePaymentWepay::WePayAccount.create(
        :account_id => account_id,
        :name => name,
        :state => state,
        :desc => desc,
        :owner_user_id => owner_user_id,
        :balances => balances,
        :statuses => statuses,
        :user_id => @user_id,
        :proj_id => @proj_id
      )
    end
    
    def refresh_wepay_account
      response = @wepay.call('/account', @access_token, {
        :account_id => @we_pay_account.account_id
      })
      puts response
      
      account_id = response['account_id']
      name = response['name']
      state = response['state']
      desc = response['description']
      owner_user_id = response['owner_user_id']
      balances = response['balances']
      statuses = response['statuses']
      
      # Found the account for the project
      # The project found account matches the account_id from WePay
      # The project found owner_user_id matches thw owner_user_id from WePay - would break WePayUser RI
      # Same account_id and owner_user_id
      if @we_pay_account && (@we_pay_account.account_id.to_i == account_id) && (@we_pay_account.owner_user_id == owner_user_id.to_s) then
        @we_pay_account.name = name
        @we_pay_account.state = state
        @we_pay_account.desc = desc
        @we_pay_account.balances = balances
        @we_pay_account.statuses = statuses        
        @we_pay_account.save
      else
        # TODO: Error from WePay -or- Key field issues -or- WePay Owner change 
      end
    end
    
    def we_pay_token
      we_pay_tokens = CatarsePaymentWepay::WePayToken.find_by_user_id @user_id.to_i
    end
    
    def we_pay_user
      we_pay_user = CatarsePaymentWepay::WePayUser.find_by_user_id @user_id.to_i
    end
     
    def we_pay_account
      we_pay_account = CatarsePaymentWepay::WePayAccount.find_by_proj_id @proj_id.to_i
    end
     
  end
end
