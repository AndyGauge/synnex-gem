module Synnex
  class Customer
    attr_reader :snx_eu_no, :company_name, :address1, :address2, :city, :state, :zip_code, :country, :contact_name, :email, :phone, :tenant_id
    def initialize(json, msp)
      @snx_eu_no = json["snx_eu_no"]
      @company_name = json["company_name"]
      @address1 = json["address1"]
      @address2 = json["address2"]
      @city = json["city"]
      @state = json["state"]
      @zip_code = json["zip_code"]
      @country = json["country"]
      @contact_name = json["contact_name"]
      @email = json["email"]
      @phone = json["phone"]
      @tenant_id = json["tenant_id"]
      @api = msp.api
    end

    def subscriptions
      @subscriptions ||= api.customer_subscription(@snx_eu_no)
                             .map {|subscription| Synnex::Subscription.new(api.subscription(subscription["subscription_id"]), self.api)}
    end

    def licenses
      api.get_licenses(tenant_access_token, @snx_eu_no)
    end

    def users
      @users ||= api.customer_users(@snx_eu_no)
    end

    # line_items is an array (optional) of the following hash {snx_sku_no: 12345, quantity: 1}
    # returns true for success
    def create_order(line_items, rs_po=nil , eu_po=nil , email=nil)
      case line_items
      when Hash
        raise "line_items must follow {snx_sku_no: 12345, quantity: 1} convention" unless (line_items[:snx_sku_no].to_i > 0 && line_items[:quantity].to_i > 0)
        line_items = [line_items]
      when Array
        raise "line_items must follow [{snx_sku_no: 12345, quantity: 1}, ...] convention" unless (line_items[0][:snx_sku_no].to_i > 0 && line_items[0][:quantity].to_i > 0)
      else
        raise "line_items must be a hash or array of hashes"
      end
      response = api.create_new_order(snx_eu_no, line_items, rs_po, eu_po, email)
      response["status"] == "success" ? true : response["message"]
    end

    def api
      @api
    end

    private

    def tenant_access_token
      return @token if @token
      body = {
          action_name: "create_tenant_access_token",
          snx_eu_no: @snx_eu_no
      }.to_json
      result = HTTParty.post("#{api.endpoint}/webservice/auth/license/token", body: body, headers: api.headers)
      @token = result.parsed_response['access_token']
    end
  end
end