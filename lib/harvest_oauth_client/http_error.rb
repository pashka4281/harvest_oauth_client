module HarvestOauthClient
  class HttpError < StandardError
    attr_reader :response, :params

    def initialize(response, params = {}, server_message = '')
      @response = response
      @params = params
      @server_message = server_message
      super(response)
    end

    def to_s
      "#{self.class.to_s} : #{response.code} URI: #{@params[:uri]} #{@server_message}"
    end
  end

  class RateLimited < HttpError; end
  class NotFound < HttpError; end
  class Unavailable < HttpError; end
  class InformHarvest < HttpError; end
  class BadRequest < HttpError; end
  class ServerError < HttpError; end
  class BadOrExpiredToken < HttpError; end
  class UnprocessibleEntry < HttpError; end
end