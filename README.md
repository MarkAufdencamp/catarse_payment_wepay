# Catarse Payment WePay support.

## Configuration for Gem Development
Name Services
/etc/hosts
	endlesscrowds.local	127.0.0.1

WePay Credentials
Acquired from WePay
Use WePay staging for development, test environments
Configured in Endlesscrowds Configuration and passed during initialization via PaymentEngines.configuration
Client_Id, Client_Secret
Set in Endlesscrowds via rails console: 
	Configuration.create(:name => "wepay_client_id", :value => "client_id")
	Configuration.create(:name => "wepay_client_secret", :value => "client_secret")

Engine config/initializers/register.rb
Reads Client_id and Client_Secret from Catarse Configuration and factories WePayConfiguration
Configuration is retrieved from the PaymentEngines.configuration.where(:name => "wepay_client_id") and PaymentEngines.configuration.where(:name => "wepay_client_secret")
WEPAY_CLIENT_ID = "client_id"
WEPAY_CLIENT_SECRET = "client_secret"

Engine test/dummy Gemfile
gem 'catarse_payment_wepay', :path => '/Users/maaufden/projects/github/catarse_payment_wepay'

Engine test/dummy Database Config

Engine Migrations
cd test/dummy
rake catarse_payment_wepay:install:migrations
rake db:migrations

Engine Landing Page
rails s -p 3001
http://endlesscrowds.local:3001/catarse_payment_wepay

## Configuration for Using Gem as rails plugin in Catarse base rails application
WePay Credentials
client_id
client_secret
Configuration.create(:name => "wepay_client_id, :value => ="client_id")
Configuration.create(:name => "wepay_client_secret, :value => ="client_secret")

Gemfile
  gem 'catarse_payment_wepay', git: 'https://github.com/MarkAufdencamp/catarse_payment_wepay.git'


Routes
  mount CatarsePaymentWepay::Engine => "/", as: "catarse_wepay"

Main Application
rake catarse_payment_wepay:install:migrations
rake db:migrate



## User
response = wepay.call('/user', access_token)

{"user_id"=>29652708,
 "first_name"=>"Mark",
 "last_name"=>"Aufdencamp",
 "user_name"=>"Mark Aufdencamp",
 "email"=>"Mark@Aufdencamp.com",
 "state"=>"registered",
 "callback_uri"=>""}


## Account Create
response = wepay.call('/account/create', access_token, {
	:name        => "test account",
	:description => "this is only a test"
})

{"account_id"=>167336302,
 "name"=>"test account",
 "state"=>"action_required",
 "description"=>"this is only a test",
 "owner_user_id"=>29652708,
 "type"=>"personal",
 "create_time"=>1475883314,
 "disablement_time"=>nil,
 "country"=>"US",
 "currencies"=>["USD"],
 "action_reasons"=>["kyc", "bank_account"],
 "disabled_reasons"=>[],
 "image_uri"=>nil,
 "supported_card_types"=>["visa", "mastercard", "american_express", "discover", "jcb", "diners_club"],
 "gaq_domains"=>[""],
 "balances"=>[{"balance"=>0, "currency"=>"USD", "disputed_amount"=>0, "incoming_pending_amount"=>0, "outgoing_pending_amount"=>0, "reserved_amount"=>0, "withdrawal_bank_name"=>nil, "withdrawal_next_time"=>nil, "withdrawal_period"=>nil, "withdrawal_type"=>nil}],
 "statuses"=>[{"currency"=>"USD", "incoming_payments_status"=>"ok", "outgoing_payments_status"=>"paused", "account_review_status"=>"not_requested"}]}

