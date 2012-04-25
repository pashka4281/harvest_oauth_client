module HarvestOauthClient
  module Restful

    class ResourceError < StandardError
      def initialize(description='')
        @description = description
      end

      def to_s
        "#{self.class.to_s}: #{@description}"
      end
    end

    class AttributeNotFound < ResourceError; end
    class ResourceNotRegistered < ResourceError; end
    class WrongResponseName < ResourceError; end
    class ParentParamsNotComplete < ResourceError; end
    
  end
end