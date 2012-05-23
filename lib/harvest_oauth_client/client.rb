module HarvestOauthClient
  class Client
    include HarvestOauthClient::CommonVars

    cattr_accessor :resources_list, :subdomain, :strict_mode
    @@resources_list = HarvestOauthClient::Restful::Resource.descendants
    attr_accessor :token
	

    def initialize(access_token, subdomain, params={})
      @@subdomain = subdomain
      @token = Rack::OAuth2::AccessToken::Bearer.new(:access_token => access_token)
      @resources = {}
      HarvestOauthClient::Restful::Resource.token = @token
      self.class.resources_list.collect{|x|  @resources[x.name.demodulize.underscore.to_sym] = x}
      @resources.keys.each do |resource|
        self.class.send(:define_method, resource) do
          @resources[resource]
        end
      end

      #checking if current access_token is valid: 
      HarvestOauthClient::Restful::Resource.who_i_am()
    end
	
    #Example:  client.resources(:project) => HarvestOauthClient::Resources::Project
    def	resources(res_name)
      raise ResourceNotRegistered.new(res_name) if !@resources.has_key?(res_name)
      @resources[res_name]
    end

  end

end