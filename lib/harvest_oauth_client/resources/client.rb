module HarvestOauthClient
  module Resources
    class Client < HarvestOauthClient::Restful::Resource

      has_many(:contacts)

      has_attributes(:name, :created_at, :details, :updated_at, :last_invoice_kind,
        :highrise_id, :id, :default_invoice_timeframe, :cache_version,
        :currency_symbol, :currency, :active)

    end
  end
end