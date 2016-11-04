# Catarse Payment WePay support.


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

