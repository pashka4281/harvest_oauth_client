module HarvestOauthClient
  class Client
    include HarvestOauthClient::CommonVars

    cattr_accessor :resources_list#, :resources
    @@resources_list = HarvestOauthClient::Restful::Resource.descendants
    attr_accessor :token
	

    def initialize(access_token, subdomain)
      @subdomain = subdomain
      @token = Rack::OAuth2::AccessToken::Bearer.new(:access_token => access_token)
      @resources = {}
      self.class.resources_list.collect{|x|  @resources[x.name.demodulize.underscore.to_sym] = x; x.token = @token}
      @resources.keys.each do |resource|
        self.class.send(:define_method, resource) do
          @resources[resource]
        end
      end
    end
	
    #Example:  client.resources(:project) => HarvestOauthClient::Resources::Project
    def	resources(res_name)
      raise ResourceNotRegistered.new(res_name) if !@resources.has_key?(res_name)
      @resources[res_name]
    end

  end

end