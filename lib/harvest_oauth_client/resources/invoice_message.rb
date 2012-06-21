module HarvestOauthClient
  module Resources
    class InvoiceMessage < HarvestOauthClient::Restful::Resource

      has_attributes(:sent_by_email, :thank_you, :include_pay_pal_link, :created_at,
                     :full_recipient_list, :bounced_at, :body, :updated_at,
                     :send_me_a_copy, :invoice_id, :bounced_emails, :subject, :id,
                     :bounce_notified_at, :sent_from, :sent_from_email, :sent_by, :bounced)

      def self.response_name
        'message'
      end

      def self.base_path
        '/messages'
      end
    end
  end
end