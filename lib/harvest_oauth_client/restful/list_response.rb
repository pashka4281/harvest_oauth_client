module HarvestOauthClient
  module Restful
    
    class ListResponse < Array

      attr_reader :current_page, :per_page, :total_entries, :total_pages

      def initialize(input, params={})
        @current_page = params[:current_page] || 1
        @per_page = params[:per_page] || 10
        @total_entries = params[:total_entries] || 1
        @total_pages = params[:total_pages] || 1

        super(input)
      end

      attr_accessor :error, :total, :total_pages

    end

  end
end
