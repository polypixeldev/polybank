module PlaidService
  def self.create_user(public_id)
    user_create_request = Plaid::UserCreateRequest.new({
      client_user_id: public_id
    })

    user_create_response = PlaidService.plaid_client.user_create(user_create_request)

    user_create_response.user_id
  end

  def self.generate_link_token(plaid_user_id)
    link_token_create_request = Plaid::LinkTokenCreateRequest.new({
      user_id: plaid_user_id,
      client_name: "Polybank",
      products: [ "transactions" ],
      country_codes: [ "US" ],
      language: "en",
      enable_multi_item_link: true
    })

    link_token_response = PlaidService.plaid_client.link_token_create(
      link_token_create_request
    )

    link_token_response.link_token
  end

  def self.get_link_token_session_info(link_token)
    link_token_get_request = Plaid::LinkTokenGetRequest.new({
      link_token:
    })

    link_token_response = PlaidService.plaid_client.link_token_get(link_token_get_request)

    link_token_response.link_sessions.last
  end

  def self.exchange_public_token(public_token)
    request = Plaid::ItemPublicTokenExchangeRequest.new
    request.public_token = public_token

    plaid_client.item_public_token_exchange(request)
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
