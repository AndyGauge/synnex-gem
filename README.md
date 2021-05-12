# Synnex::Gem

Use this gem to interact with Synnex API to query against office 365
CSP.  It is possible to get customers, purchase subscriptions, and manage
seats

### To connect to the API, start with the Synnex::Msp object

`msp = Synnex::Msp.new(user_name: 'user', password: 'pass', reseller: 12345)`
to use the production instance include `endpoint: "production"`

### To get customers

`msp.customers`

### Synnex::Customer

The customer object has the following attributes:
 - snx_eu_no
 - company_name
 - address1
 - address2
 - city
 - state
 - zip_code
 - country
 - contact_name
 - email
 - phone
 - tenant_id
 
Customer can also perform the following operations:
 - `create_order(line_items, reseller_po, end_user_po, email)`
   - `line_items` follow the `{snx_sku_no: 12345, quantity: 1}` pattern
   
subscriptions for a customer can be queried and manipulated by calling 
`.subscriptions` on the `Synnex::Customer` object 