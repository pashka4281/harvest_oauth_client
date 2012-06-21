module HarvestOauthClient
  module Resources
    class InvoicePayment < HarvestOauthClient::Restful::Resource

      has_attributes(:created_at, :pay_pal_transaction_id, :notes, :recorded_by_email, :updated_at,
                     :amount, :invoice_id, :payment_gateway_id, :authorization, :id, :recorded_by, :paid_at)

      def self.base_path
        '/payments'
      end

      def self.response_name
        'payment'
      end
    end
  end
end