require 'rubygems'
require 'active_support/all'
require 'rack/oauth2'
require 'harvest_oauth_client'
require 'bundler/setup'

def random_hash(power)
	rand(2**power).to_s(16)
end

def get_access_token()
	"EV4F5WFLvecjnl7+TOpwlMF75z2NEG0VpDB4/mKUQ7UpRYT8W4kRmPq4TOG4q7xg5njZCNXnWYSCrnYx66eCgQ=="
end

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.color = true
  #  config.treat_symbols_as_metadata_keys_with_true_values = true
  #  config.run_all_when_everything_filtered = true
  #  config.filter_run :focus
end
