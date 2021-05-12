require 'httparty'
require 'synnex/synnex_customer'
require 'synnex/synnex_subscription'
require 'synnex/synnex_api'
require 'synnex/synnex_msp'

# Use msp = Synnex::Msp.new(user_name: 'user', password: 'pass', reseller: 12345)
# msp.customers.first.subscriptions.first
module Synnex
  UAT = 'https://testws.synnex.com'
  PROD = 'https://ws.synnex.com'
  HEADERS = {
      'Content-Type' => 'application/json'
  }
end
