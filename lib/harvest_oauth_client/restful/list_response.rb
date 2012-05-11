module HarvestOauthClient
  module Restful
    
    class ListResponse < Array

      attr_reader :current_page, :per_page, :total_entries, :total_pages

      def initialize(args)
        @current_page = 1
        @per_page = 10
        @total_entries = 1
        @total_pages = 1

        super(args)
      end

      attr_accessor :error, :total, :total_pages


    end

  end
end
