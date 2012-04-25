module HarvestOauthClient
  module Resources
    class Category < HarvestOauthClient::Restful::Resource # Invoice Item Category

      has_attributes(:name, :created_at, :updated_at, :use_as_expense, :use_as_service, :id)

      def self.base_path
        "/invoice_item_categories"
      end

    end
  end
end