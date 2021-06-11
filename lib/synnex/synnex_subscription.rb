module Synnex
  class Subscription
    attr_reader :id, :service_name, :snx_sku_no, :quantity, :status, :po, :price, :msrp, :customer
    def initialize(json, api)
      info = json["subscriptions_info"][0]
      @id = info["subscription_id"]
      @service_name = info["service_name"]
      @snx_sku_no = info["snx_sku_no"]
      @quantity = info["quantity"]
      @status = info["status"]
      @po = json["rs_po_no"]
      @price = info["unit_price"]
      @msrp = info["msrp"]
      @api = api
    end

    def change_quantity(qty, email=nil)
      raise "Quantity must be greater than 0" unless qty > 0
      response = api.update_seat(id, qty, email)
      response["status"] == "success" ? true : response["message"]
    end

    def cancel(email=nil)
      response = api.cancel_subscription(id, email)
      response["status"] == "success" ? true : response["message"]
    end

    private

    def api
      @api
    end

  end
end