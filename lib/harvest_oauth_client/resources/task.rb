module HarvestOauthClient
  module Resources
    class Task < HarvestOauthClient::Restful::Resource

      has_attributes(:name, :created_at, :billable_by_default, :is_default, :updated_at,
                      :id, :cache_version, :deactivated, :default_hourly_rate)

    end
  end
end