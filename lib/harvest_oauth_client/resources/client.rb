module HarvestOauthClient
  module Resources
    class Client < HarvestOauthClient::Restful::Resource

      has_many(:contacts)

      has_attributes(:name, :created_at, :details, :updated_at, :last_invoice_kind,
        :highrise_id, :id, :default_invoice_timeframe, :cache_version,
        :currency_symbol, :currency, :active)

      class << self
        alias :get :find

        def create_with_contacts(params={})
          client = self.create(:name => [params[:first_name], params[:last_name]].join(' '))
          contact_params ={
            :email        => params[:email],
            :first_name   => params[:first_name],
            :last_name    => params[:last_name],
            :phone_office => params[:work_phone],
            :parent_id    => client.id
          }
          HarvestOauthClient::Resources::Contact.create(contact_params)
          client
        end
      end
    end
  end
end