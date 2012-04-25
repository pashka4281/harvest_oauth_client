module HarvestOauthClient
  module Resources
    class Contact < HarvestOauthClient::Restful::Resource #(ClientContact)

      has_attributes(:created_at, :title, :updated_at, :phone_office, :id,
                      :client_id, :fax, :last_name, :email, :first_name, :phone_mobile)

    end
  end
end