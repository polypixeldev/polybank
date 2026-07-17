module PlaidService
  def self.generate_link_token(public_id)
    link_token_create_request = Plaid::LinkTokenCreateRequest.new({
      user: { client_user_id: public_id },
      client_name: "My app",
      products: %w[auth transactions],
      country_codes: [ "US" ],
      language: "en"
    })

    link_token_response = PlaidService.plaid_client.link_token_create(
      link_token_create_request
    )

    link_token_response.link_token
  end

  def self.exchange_public_token(public_token)
    request = Plaid::ItemPublicTokenExchangeRequest.new
    request.public_token = public_token

    response = plaid_client.item_public_token_exchange(request)
    response.access_token
  end

  def self.plaid_client
    configuration = Plaid::Configuration.new
    configuration.server_index = Plaid::Configuration::Environment["production"]
    configuration.api_key["PLAID-CLIENT-ID"] = ENV["PLAID_CLIENT_ID"]
    configuration.api_key["PLAID-SECRET"] = ENV["PLAID_CLIENT_SECRET"]

    api_client = Plaid::ApiClient.new(
      configuration
    )

    Plaid::PlaidApi.new(api_client)
  end
end
