$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "harvest_oauth_client/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "harvest_oauth_client"
  s.version     = HarvestOauthClient::VERSION
  s.authors     = ["Paul Ser"]
  s.email       = ["pashka4281@gmail.com"]
  s.summary     = "A Harvestapp.com API wrapper gem with oauth2 support"
  s.description = ""

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  #s.add_dependency "rails", "~> 3.2.3"
  #
  #s.add_development_dependency "sqlite3"
end
