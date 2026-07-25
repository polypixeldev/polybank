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
      enable_multi_item_link: true,
      transactions: {
        days_requested: 730
      },
      webhook: Rails.application.routes.url_helpers.plaid_webhook_url
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

  def self.get_item_data(access_token)
    item_get_request = Plaid::ItemGetRequest.new({
      access_token:
    })

    plaid_client.item_get(item_get_request).item
  end

  def self.get_item_accounts(access_token)
    Rails.cache.fetch("item_#{access_token}_accounts", expires_in: 1.minute) do
      accounts_get_request = Plaid::AccountsGetRequest.new({
        access_token:
      })

      plaid_client.accounts_get(accounts_get_request).accounts
    end
  end

  def self.get_webhook_verification_key(key_id)
    webhook_verification_key_get_request = Plaid::WebhookVerificationKeyGetRequest.new({
      key_id:
    })

    plaid_client.webhook_verification_key_get(webhook_verification_key_get_request).key
  end

  def self.sync_transactions(access_token, cursor: nil)
    transactions_sync_request = Plaid::TransactionsSyncRequest.new({
      access_token:,
      cursor:,
      options: {
        include_original_description: true
      }
    })

    plaid_client.transactions_sync(transactions_sync_request)
  end

  def self.refresh_transactions(access_token)
    transactions_refresh_request = Plaid::TransactionsRefreshRequest.new({
      access_token:
    })

    plaid_client.transactions_refresh(transactions_refresh_request)
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
