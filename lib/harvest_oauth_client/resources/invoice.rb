module HarvestOauthClient
  module Resources
    class Invoice < HarvestOauthClient::Restful::Resource
      has_many(:invoice_messages)
      has_many(:invoice_payments)

      has_attributes(:tax2_amount, :tax2, :client_key, :recurring_invoice_id, :currency, :purchase_order, :state,
        :period_start, :issued_at, :retainer_id, :notes, :created_at, :discount, :discount_amount,
        :updated_at, :estimate_id, :amount, :period_end, :tax, :tax_amount, :due_at, :client_id,
        :due_at_human_format, :due_amount, :id, :subject, :created_by_id, :number, :csv_line_items)

      attr_accessor :status_class

      class << self
        alias :get :find

        #TODO: somehow needs to be fixed (probably only by contacting harvest support)
        # http://www.getharvest.com/api/invoices
        #You can also filter by client, for example to show only the invoices belonging to client with the id 23445
        #GET /invoices?client=23445
        #but this type of sorting seems to be broken and don't works within Harvest API
        def for_client(client_id, params ={})
          self.all({:uri_params => {:client => client_id}}.deep_merge(params))
        end

        def list(client_id, page)
          page ||= 1
          self.for_client(client_id, {:uri_params => {:page => page}})
        end

        def count(client_id)
          super(:uri_params => {:client => client_id})
        end

        def	create(params = {})
          parent_id = params.delete(:parent_id)
          resp = request(:post, self.make_uri(nil, parent_id, params[:uri_params]), JSON('invoice' => params))
          self.new(params.merge(:id => resp.headers['Location'].gsub(/\D/, '').try(:to_i)))
        end

        #TODO: implement overloaded create() method to allow creating invoice from the proposal:
        #or fix freshbooks invoice.create method to accept hash parameters...
#        def create(client_id, proposal = nil)
#          params = {:state => 'draft', :client_id => client_id}
#          params.merge!(self.populate_from_proposal(proposal)) unless proposal.blank? || proposal.proposalfees.empty?
#          self.create(params)
#        end
      end

      #TODO: complete next methods:
      def status_class
        case self.state
        when 'paid'
          @status_class = 'won'
        when 'partial'
          @status_class = 'part-paid'
        else
          @status_class = self.state
        end
      end

      def status
        self.state
      end

      def name
        self.subject
      end

      def invoice_url
        "https://#{HarvestOauthClient::Client.subdomain}/invoices/#{self.id}"
      end

      def currency_code
        "$"
      end

      alias :date :issued_at

      private

      def self.response_name
        'doc'
      end

      #fix it
      def self.populate_from_proposal(proposal)
          lines = []
          proposal_template = ProposalTemplate.new(proposal)
          proposal.proposalfees.each do |pfee|

            proposal_template.content = pfee.description
            proposal_template.populate
            description = ActionController::Base.helpers.strip_tags(proposal_template.content)
            lines << { :line => {
                :name         => pfee.name,
                :description  => description,
                :unit_cost    => pfee.amount,
                :quantity     => 1
              }}
          end
          { :lines => lines }
          {} #returning empty hash for now
        end

    end
  end
end