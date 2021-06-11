module Synnex
  class Msp
    attr_reader :api
    # Pass the parameters to Synnex::Msp.new(user_name: 'user', password: 'pass', reseller: 12345)
    # Pass the parameter {endpoint: 'production'} for the production endpoint
    def initialize(hash)
      @api = Synnex::API.new(hash)
    end

    def customers
      @customers ||= api.customers.map {|json| Synnex::Customer.new(json, self)}
    end

    def find_customer(snx_eu_no)
      customers.find {|c| c.snx_eu_no == snx_eu_no}
    end

    def find_subscription(id)
      Synnex::Subscription.new(api.subscription(id), @api)
    end

  end
end