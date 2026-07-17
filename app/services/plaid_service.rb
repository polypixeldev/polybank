module PlaidService
  def self.generate_link_token
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
