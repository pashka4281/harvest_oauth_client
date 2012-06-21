require File.expand_path('../harvest_oauth_client/restful/list_response',__FILE__)
require File.expand_path('../harvest_oauth_client/http_error',__FILE__)
require File.expand_path('../harvest_oauth_client/currency_helper',__FILE__)
require File.expand_path('../harvest_oauth_client/restful/resource_error',__FILE__)
require File.expand_path('../harvest_oauth_client/common_vars',__FILE__)
require File.expand_path('../harvest_oauth_client/restful/resource',__FILE__)

#Dir.glob(File.expand_path('../harvest_oauth_client/resources/*.rb', __FILE__)).each {|resource|  require resource }
#explicit loading resources files:
require File.expand_path('../harvest_oauth_client/resources/project.rb',__FILE__)
require File.expand_path('../harvest_oauth_client/resources/client.rb',__FILE__)
require File.expand_path('../harvest_oauth_client/resources/invoice.rb',__FILE__)
require File.expand_path('../harvest_oauth_client/resources/contact.rb',__FILE__)
require File.expand_path('../harvest_oauth_client/resources/task.rb',__FILE__)
require File.expand_path('../harvest_oauth_client/resources/invoice_message.rb',__FILE__)
require File.expand_path('../harvest_oauth_client/resources/expense_category.rb',__FILE__)
require File.expand_path('../harvest_oauth_client/resources/task_assignment.rb',__FILE__)
require File.expand_path('../harvest_oauth_client/resources/category.rb',__FILE__)
require File.expand_path('../harvest_oauth_client/resources/common_vars.rb',__FILE__)
require File.expand_path('../harvest_oauth_client/resources/invoice_payment.rb',__FILE__)
require File.expand_path('../harvest_oauth_client/resources/user.rb',__FILE__)

require File.expand_path('../harvest_oauth_client/client',__FILE__)


module HarvestOauthClient

  def self.create(access_token, subdomain, params={})
    HarvestOauthClient::Client.new(access_token, subdomain, params)
  end

end
