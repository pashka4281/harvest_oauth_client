module HarvestOauthClient
  module Resources
    class Invoice < HarvestOauthClient::Restful::Resource
      has_many(:invoice_messages)
      has_many(:invoice_payments)

      #TODO: somehow needs to be fixed (probably only by contacting harvest support)
      # http://www.getharvest.com/api/invoices
      #You can also filter by client, for example to show only the invoices belonging to client with the id 23445
      #GET /invoices?client=23445
      #but this type of sorting seems to be broken and don't works within Harvest API
      def self.for_client(client_id, params ={})
        self.all({:uri_params => {:client => client_id}}.deep_merge(params))
      end

      def self.list(client_id, page)
        self.for_client(client_id, {:uri_params => {:page => page}})
      end

      def self.count(client_id)
        super(:uri_params => {:client => client_id})
      end

      def self.invoice_totals(external_id, start_date)
        
      end

      has_attributes(:tax2_amount, :tax2, :client_key, :recurring_invoice_id, :currency, :purchase_order, :state,
                     :period_start, :issued_at, :retainer_id, :notes, :created_at, :discount, :discount_amount,
                     :updated_at, :estimate_id, :amount, :period_end, :tax, :tax_amount, :due_at, :client_id,
                     :due_at_human_format, :due_amount, :id, :subject, :created_by_id, :number, :csv_line_items)

      private

      def self.response_name
        'doc'
      end


      def status_class
        self.state
      end



    end
  end
end