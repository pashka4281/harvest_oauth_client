module HarvestOauthClient
  class HttpError < StandardError
    attr_reader :response, :params

    def initialize(response, params = {})
      @response = response
      @params = params
      super(response)
    end

    def to_s
      "#{self.class.to_s} : #{response.code} URI: #{@params[:uri]}"
    end
  end

  class RateLimited < HttpError; end
  class NotFound < HttpError; end
  class Unavailable < HttpError; end
  class InformHarvest < HttpError; end
  class BadRequest < HttpError; end
  class ServerError < HttpError; end
  class BadOrExpiredToken < HttpError; end
end
