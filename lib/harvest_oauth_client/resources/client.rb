module HarvestOauthClient
  module Resources
    class Client < HarvestOauthClient::Restful::Resource

      has_attributes(:name, :created_at, :details, :updated_at, :last_invoice_kind,
        :highrise_id, :id, :default_invoice_timeframe, :cache_version,
        :currency_symbol, :currency, :active)
      
      attr_accessor :not_found

      has_many(:contacts)

      class << self
        def get(id, params={})
          begin
            resp_hash = JSON.parse(show(id, params).body)[response_name()]
            client = self.new(resp_hash)
          rescue HarvestOauthClient::NotFound
            client = self.new(:not_found => true)
          end
          client
        end

        def create_with_contacts(params={})
          begin
            client = self.create(:name => [params[:first_name], params[:last_name]].join(' '))
          rescue HarvestOauthClient::BadRequest => e
            return self.new(:error => e.server_message)
          rescue HarvestOauthClient::ServerError => e
            return self.new(:error => e.server_message)
          end
          contact_params ={
            :email        => params[:email],
            :first_name   => params[:first_name],
            :last_name    => params[:last_name],
            :phone_office => params[:work_phone],
            :parent_id    => client.id
#            :client_id    => client.id
          }
          HarvestOauthClient::Resources::Contact.create(contact_params)
          client
        end
      end
    end
  end
end