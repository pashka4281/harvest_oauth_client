module HarvestOauthClient
  module Resources
    class Invoice < HarvestOauthClient::Restful::Resource
      has_many(:invoice_messages)
      has_many(:invoice_payments)

      has_attributes(:tax2_amount, :tax2, :client_key, :recurring_invoice_id, :currency, :purchase_order, :state,
        :period_start, :issued_at, :retainer_id, :notes, :created_at, :discount, :discount_amount,
        :updated_at, :estimate_id, :amount, :period_end, :tax, :tax_amount, :due_at, :client_id,
        :due_at_human_format, :due_amount, :id, :subject, :created_by_id, :number, :csv_line_items)

      attr_accessor :status_class, :not_found

      class << self
        
        def get(id, params={})
          begin
            resp_hash = JSON.parse(show(id, params).body)[response_name()]
            invoice = self.new(resp_hash)
          rescue HarvestOauthClient::NotFound
            invoice = self.new(:not_found => true)
          end
          invoice
        end

        #You can also filter by client, for example to show only the invoices belonging to client with the id 23445
        #GET /invoices?client=23445
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
        
        def update(id, params = {})
          parent_id = params.delete(:parent_id)
          request(:put, self.make_uri(id, parent_id, params[:uri_params]), JSON('invoice' => params))
        end

        def	create(params = {})
          parent_id = params.delete(:parent_id)
          resp = request(:post, self.make_uri(nil, parent_id, params[:uri_params]), JSON({'invoice' => params}))
#          self.new(params.merge(:id => resp.headers['Location'].gsub(/\D/, '').try(:to_i)))
          self.find(resp.headers['Location'].gsub(/\D/, '').try(:to_i))
        end

        def create_from_proposal(client_id, proposal = nil)
          params = {:state => 'draft', :client_id => client_id, :subject => (!!proposal ? proposal.project_name : '')}
          params.merge!(self.populate_from_proposal(proposal)) unless proposal.blank? || proposal.proposalfees.empty?
          self.create(params)
        end

        def response_name
          'doc'
        end
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
        self.subject.blank? ? invoice_url : self.subject
      end

      def invoice_url
        "https://#{HarvestOauthClient::Client.subdomain}/invoices/#{self.id}"
      end

      #currency looks like "Euro - EUR" or "United States Dollars - USD"
      # so just need to get 3 last characters from it
      def currency_code
        self.currency.blank? ? '' : self.currency[-3..-1]
      end

      alias :date :issued_at

      private

      def self.populate_from_proposal(proposal)
        csv_lines = [%w(kind description quantity unit_price amount taxed taxed2 project_id)]
        proposal.proposalfees.each do |pf|
          csv_lines << ["Service", pf.name, 1, pf.amount_cents / 100, pf.amount_cents / 100, false, false, '']
        end
        {:amount => proposal.all_fees_total.dollars, :csv_line_items => csv_lines.collect{|x| x.join(',')}.join("\n") }
      end

    end
  end
end