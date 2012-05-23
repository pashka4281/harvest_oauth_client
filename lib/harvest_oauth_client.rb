require File.expand_path('../harvest_oauth_client/restful/list_response',__FILE__)
require File.expand_path('../harvest_oauth_client/http_error',__FILE__)
require File.expand_path('../harvest_oauth_client/restful/resource_error',__FILE__)
require File.expand_path('../harvest_oauth_client/common_vars',__FILE__)
require File.expand_path('../harvest_oauth_client/restful/resource',__FILE__)
Dir.glob(File.expand_path('../harvest_oauth_client/resources/*.rb', __FILE__)).each {|resource|  require resource }
require File.expand_path('../harvest_oauth_client/client',__FILE__)


module HarvestOauthClient

  def self.create(access_token, subdomain, params={})
    HarvestOauthClient::Client.new(access_token, subdomain, params)
  end

end
