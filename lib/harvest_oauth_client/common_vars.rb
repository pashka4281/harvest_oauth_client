 module HarvestOauthClient
  module CommonVars
    
    def self.included(base)
      base.send :include, InstanceVars
      base.send :extend, ClassVars
    end


    module ClassVars
      API_HOST = "https://api.harvestapp.com"
    end
    
    module InstanceVars
      NOT_UPDATEABLE_KEYS = [:id]
    end
    
  end
end