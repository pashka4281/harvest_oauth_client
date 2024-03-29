module HarvestOauthClient
  module Restful
    class Resource
	    include HarvestOauthClient::CommonVars


      @@descendants = []
      @@descendants_names = []
      @@descendants_hash = {}

      attr_accessor :error
      cattr_writer :token
      cattr_reader :descendants, :descendants_hash
      cattr_accessor :list_response_class
      @@list_response_class = HarvestOauthClient::Restful::ListResponse #HarvestOauthClient::Restful::Response or other class inherited form it
	
      #constructor
      def initialize(params={})
        raise WrongResponseName.new if params.nil?
        params.stringify_keys!
        params.each{|key, value| self.send("#{key.underscore}=", value) }
      end

      #instance methods: 
      def save
        attrs_with_vals = {}
        attrs_with_vals[:parent_id] = self.send(self.class.parent_info[:key]) if !self.class.parent_info.blank?
        self.class.attributes.reject{|x| NOT_UPDATEABLE_KEYS.include?(x) }.each{|attr| attrs_with_vals[attr] = self.send(attr) }
        begin
          self.class.update(self.id, attrs_with_vals)
        rescue HttpError => e
          puts e
          return false
        end
        return true
      end

      def delete
        raise BlankIdError.new("Can't delete resource without an id") if self.id.blank?
        params = {}
        params[:parent_id] = self.send(self.class.parent_info[:key]) if !self.class.parent_info.blank?
        begin
          self.class.delete(self.id, params)
        rescue HttpError => e
          puts e
          return false
        end
        return true
      end


	    #class methods:
      class << self
        def inherited(klass)
          @@descendants << klass
          @@descendants_names << klass.name.demodulize.underscore.to_sym
          @@descendants_hash[klass.name.demodulize.underscore.to_sym] = klass
        end

        def attributes
          @attributes
        end

        def has_attributes(*args)
          @attributes = args
          this = self
          @attributes.each{|attr| this.send(:attr_accessor, attr)}
        end

        def parent_info
          @parent_info
        end

        #<=== resources relations methods:
        def belongs_to(res, params={})
          foreign_key = params.delete(:foreign_key) || res.to_s.gsub(':','').foreign_key
          raise ResourceNotRegistered.new(res) unless @@descendants_names.include?(res)
          @parent_class = @@descendants_hash[res]
          @parent_class_name = res
          @parent_info = {:class => @parent_class, :name => @parent_class_name, :key => foreign_key}

          define_method(res) do
            raise AttributeNotFound.new(foreign_key) if self.class.attributes[foreign_key.to_sym].blank?
            self.class.descendants_hash[res].find(self.send(foreign_key.to_sym))
          end
        end

        def has_many(resources, params={})
          define_method(resources) do
            self.class.descendants_hash[resources.to_s.singularize.to_sym].all(:parent_id => self.id)
          end
        end
        # ===> end

        #<=== URI building methods:
        def base_path()
          '/' + self.name.demodulize.underscore.pluralize
        end

        def make_path(id=nil, parent_id=nil)
          if (!parent_id.nil? && @parent_class_name.nil?) || (parent_id.nil? && !@parent_class_name.nil?)
            raise ParentParamsNotComplete.new("You should specify both belongs_to() and :parent_id for relative associations")
          end

          # prepend this if belongs_to declared:
          prefix = parent_id.blank? ? '': "/#{@parent_class_name.to_s.gsub(':','').pluralize}/#{parent_id}"

          path = id.nil? ? base_path() : base_path() + "/#{id}"
          prefix + path
        end

        def make_uri(id=nil, parent_id=nil, uri_params={})
          uri_params ||= {}
          http_params = uri_params.empty? ? '' : "?#{uri_params.to_params}"
          API_HOST + make_path(id, parent_id) + http_params #API_HOST is declared in HarvestOauthClient::CommonVars module
        end
        # ===> end

        #<=== REST methods:

        def index(params={})
          parent_id = params.delete(:parent_id)
          request(:get, self.make_uri(nil, parent_id, params[:uri_params]))
        end

        def delete(id, params={})
          parent_id = params.delete(:parent_id)
          request(:delete, self.make_uri(id, parent_id, params[:uri_params]))
        end

        def show(id, params={})
          parent_id = params.delete(:parent_id)
          request(:get, self.make_uri(id, parent_id, params[:uri_params]))
        end

        def update(id, params = {})
          parent_id = params.delete(:parent_id)
          request(:put, self.make_uri(id, parent_id, params[:uri_params]), JSON(response_name => params))
        end

        def	create(params = {})
          parent_id = params.delete(:parent_id)
          resp = request(:post, self.make_uri(nil, parent_id, params[:uri_params]), JSON(response_name => params))
          self.new(params.merge(:id => resp.headers['Location'].gsub(/\D/, '').try(:to_i)))
        end
        # <==== end

        #
        def response_name
          self.name.demodulize.underscore
        end

        def	count(params={})
          page = params[:uri_params].try(:[], :page) || 1
          amount = 0
          while page < 10
            cnt = JSON.parse(index(params).body).count
            amount += cnt
            page += 1
            params.merge!(:uri_params=>{:page => page})
            return amount if cnt < 50
          end
          amount
        end

        def	all(params={})
          this = self
          page = params[:uri_params].try(:[], :page) || 1
          all_items = []
          while page < 10
            current_set = JSON.parse(index(params).body).collect{|x| this.new(x[response_name()])}
            all_items += current_set
            page += 1
            params.merge!(:uri_params=>{:page => page})
            return @@list_response_class.new(all_items) if current_set.count < 50
          end
          @@list_response_class.new(all_items)
        end

        def	find(id, params={})
          resp_hash = JSON.parse(show(id, params).body)[response_name()]
          self.new(resp_hash)
        end

        #basic account info,
        #light-weight call, could be used for checking the api for accessibility
        def who_i_am
          JSON.parse(request(:get, "https://api.harvestapp.com/account/who_am_i").body)
        end

        protected

        def request(method, uri, options = {})
          params = {}
          params[:uri] = uri
          params[:options] = options
          params[:method] = method

          headers = [['Accept', 'application/json'], ['Content-Type', 'application/json']]
          response = @@token.send(method, uri, options, headers)   #options should be JSON array

          puts "[HARVEST] #{method.to_s.upcase}: #{uri}"
#          puts params.inspect
          case response.code
            when 200..201
              response
            when 400
              raise HarvestOauthClient::BadRequest.new(response, params, @error) 
            when 401
              raise HarvestOauthClient::BadOrExpiredToken.new(response, params)
            when 404
              raise HarvestOauthClient::NotFound.new(response, params) 
            when 422
              raise HarvestOauthClient::UnprocessibleEntry.new(response, params, @error)
            when 500
              raise HarvestOauthClient::ServerError.new(response, params)
            when 502
              raise HarvestOauthClient::Unavailable.new(response, params, @error)
            when 503
              raise HarvestOauthClient::RateLimited.new(response, params)
            else
              raise HarvestOauthClient::InformHarvest.new(response, params)
          end
        end

      end
	
    end


  end
end