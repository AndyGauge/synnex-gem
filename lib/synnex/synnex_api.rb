module Synnex

  class API

    # Pass the parameters to Synnex::API.new(user_name: 'user', password: 'pass', reseller: 12345)
    # Pass the parameter {endpoint: 'production'} for the production endpoint
    def initialize(hash)
      raise "user_name is required" unless hash[:user_name]
      raise "password is required" unless hash[:password]
      raise "reseller is required" unless hash[:reseller]
      @user_name = hash[:user_name]
      @password = hash[:password]
      @reseller = hash[:reseller]
      @endpoint = hash[:endpoint] == 'production' ? Synnex::PROD : Synnex::UAT
      get_auth_token
      @headers = {'Authorization' => "Bearer #{@access_token}"}.merge(Synnex::HEADERS)
    end

    def customers
      @customers ||= HTTParty.post("#{@endpoint}/webservice/solutions/csp",
                                   body: {action_name: 'get_eu_list'}.to_json,
                                   headers: @headers)
                         .parsed_response["items"]
                         .select {|customers| customers['tenant_id']}
    end

    def customer_subscription(cust_no)
      HTTParty.post("#{@endpoint}/webservice/solutions/csp",
                    body: {
                        action_name: 'get_subscriptions_by_eu_no',
                        snx_eu_no: cust_no
                    }.to_json,
                    headers: @headers)
          .parsed_response["items"]
    end

    def subscription(id)
      HTTParty.post("#{@endpoint}/webservice/solutions/csp",
                    body: {
                        action_name: 'get_subscription_by_id',
                        subscription_id: id
                    }.to_json,
                    headers: @headers)
          .parsed_response["items"]
    end

    def create_new_order(cust_no, li, rs, eu, email)
      body = {
          action_name: 'create_new_order',
          snx_eu_no: cust_no,
          line_items: li,
      }
      body[:rs_po_no] = rs if rs
      body[:eu_po_no] = eu if eu
      body[:notify_email] = email if email
      HTTParty.post("#{@endpoint}/webservice/solutions/csp",
                    body: body.to_json,
                    headers: @headers)
          .parsed_response
    end

    def update_seat(subscription, quantity, email)
      body = {
          action_name: "update_seat",
          subscription_id: subscription,
          new_quantity: quantity
      }
      body[:notify_email] = email if email
      p body.to_json
      HTTParty.post("#{@endpoint}/webservice/solutions/csp",
                    body: body.to_json,
                    headers: @headers)
          .parsed_response

    end

    def cancel_subscription(subscription, email)
      body = {
          action_name: "cancel",
          subscription_id: subscription,
      }
      body[:notify_email] = email if email
      HTTParty.post("#{@endpoint}/webservice/solutions/csp",
                    body: body.to_json,
                    headers: @headers)
          .parsed_response
    end



    private

    def get_auth_token
      body = {
          action_name: "create_access_token",
          user_name: @user_name,
          password: @password,
          snx_reseller_no: @reseller
      }.to_json
      result = HTTParty.post("#{@endpoint}/webservice/auth/token", body: body, headers: Synnex::HEADERS)
      @access_token = result.parsed_response['access_token']
      raise "Invalid Credentials" unless @access_token
    end
  end
end