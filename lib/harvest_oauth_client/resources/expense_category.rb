module HarvestOauthClient
  module Resources
    class ExpenseCategory < HarvestOauthClient::Restful::Resource

      has_attributes(:name, :created_at, :updated_at, :id, :unit_price, :cache_version, :deactivated, :unit_name)

    end
  end
end