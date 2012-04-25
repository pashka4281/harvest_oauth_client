module HarvestOauthClient
  module Restful
    class Resource
	    include HarvestOauthClient::CommonVars

      @@descendants = []
      @@descendants_names = []
      @@descendants_hash = {}

      cattr_writer :token
      cattr_reader :descendants, :descendants_hash
	
      #constructor
      def initialize(params={})
        raise WrongResponseName.new if params.nil?
        params.stringify_keys!
        params.each{|key, value| self.send("#{key.underscore}=", value) }
      end

      def save
        attrs_with_vals = {}
        self.class.attributes.reject{|x| NOT_UPDATEABLE_KEYS.include?(x) }.each{|attr| attrs_with_vals[attr] = self.send(attr) }
        begin
          self.class.update(self.id, attrs_with_vals)
        rescue HttpError => e.inspect
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

        #<=== resources relations methods:
        def belongs_to(res, params={})
          foreign_key = params.delete(:foreign_key) || res.to_s.gsub(':','').foreign_key
          raise ResourceNotRegistered.new(res) unless @@descendants_names.include?(res)
          @parent_class = @@descendants_hash[res]
          @parent_name = res

          define_method(res) do
            #raise AttributeNotFound.new(foreign_key) if @attributes[foreign_key.to_sym].blank?
            self.class.descendants_hash[res].show_obj(self.send(foreign_key.to_sym))
          end
        end

        def has_many(resources, params={})
          define_method(resources) do
            self.class.descendants_hash[resources.to_s.singularize.to_sym].index_obj(:parent_id => self.id)
          end
        end
        # ===> end

        #<=== URI building methods:
        def base_path()
          '/' + self.name.demodulize.underscore.pluralize
        end

        def make_path(id=nil, parent_id=nil)
          if (!parent_id.nil? && @parent_name.nil?) || (parent_id.nil? && !@parent_name.nil?)
            raise ParentParamsNotComplete.new("You should specify both belongs_to() and :parent_id for relative associations")
          end

          # prepend this if belongs_to declared:
          prefix = parent_id.blank? ? '': "/#{@parent_name.to_s.gsub(':','').pluralize}/#{parent_id}"
          # append this if has_many declared:
          postfix = '' #TODO: finish this

          path = id.nil? ? base_path() + '.json' : base_path() + "/#{id}.json"
          prefix + path + postfix
        end

        def make_uri(id=nil, parent_id=nil)
          API_HOST + make_path(id, parent_id) #API_HOST is declared in HarvestOauthClient::CommonVars module
        end
        # ===> end

        #<=== REST methods:

        def index(params={})
          parent_id = params.delete(:parent_id)
          resp = request(:get, self.make_uri(nil, parent_id))
        end

        def delete(id, params={})
          parent_id = params.delete(:parent_id)
          resp = request(:delete, self.make_uri(id, parent_id))
        end

        def show(id, params={})
          parent_id = params.delete(:parent_id)
          resp = request(:get, self.make_uri(id, parent_id))
        end

        def update(id, params = {})
          parent_id = params.delete(:parent_id)
          resp = request(:put, self.make_uri(id, parent_id), JSON(response_name => params))
        end

        def	create(params = {})
          parent_id = params.delete(:parent_id)
          resp = request(:post, self.make_uri(nil, parent_id), JSON(response_name => params))
        end
        # <==== end

        #
        def response_name
          self.name.demodulize.underscore
        end

        def	all(params={})
          resp_arr = JSON.parse(index(params).body)
          this = self
          resp_arr.collect{|x| this.new(x[response_name()])}
        end

        def	find(id, params={})
          resp_hash = JSON.parse(show(id, params).body)[response_name()]
          self.new(resp_hash)
        end

        protected

        def request(method, uri, options = {})
          params = {}
          params[:uri] = uri
          params[:options] = options
          params[:method] = method

          response = @@token.send(method, uri, options)   #options should be JSON array

          params[:response] = response.inspect.to_s
          case response.code
            when 200..201
              response
            when 400
              raise HarvestOauthClient::BadRequest.new(response, params)
            when 401
              raise HarvestOauthClient::BadOrExpiredToken.new(response, params)
            when 404
              raise HarvestOauthClient::NotFound.new(response, params)
            when 500
              raise HarvestOauthClient::ServerError.new(response, params)
            when 502
              raise HarvestOauthClient::Unavailable.new(response, params)
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