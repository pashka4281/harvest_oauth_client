require 'rubygems'
require 'active_support/all'
require 'rack/oauth2'
require 'harvest_oauth_client'
require 'bundler/setup'


# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.color = true
  #  config.treat_symbols_as_metadata_keys_with_true_values = true
  #  config.run_all_when_everything_filtered = true
  #  config.filter_run :focus
end
