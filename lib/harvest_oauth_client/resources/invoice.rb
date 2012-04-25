module HarvestOauthClient
  module Resources
    class Invoice < HarvestOauthClient::Restful::Resource
      #attr_required :client_id
      has_many(:invoice_messages)
      has_many(:invoice_payments)

      has_attributes(:tax2_amount, :tax2, :client_key, :recurring_invoice_id, :currency, :purchase_order, :state,
                     :period_start, :issued_at, :retainer_id, :notes, :created_at, :discount, :discount_amount,
                     :updated_at, :estimate_id, :amount, :period_end, :tax, :tax_amount, :due_at, :client_id,
                     :due_at_human_format, :due_amount, :id, :subject, :created_by_id, :number, :csv_line_items)



      def self.response_name
        'doc'
      end

    end
  end
end