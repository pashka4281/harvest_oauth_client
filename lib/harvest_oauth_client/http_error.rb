module HarvestOauthClient
  class HttpError < StandardError
    attr_reader :response, :params, :message

    def initialize(response, params = {})
      @response = response
      @params = params
      @message = JSON.parse(response.body)['message']
      super(response)
    end

    def to_s
      error_message = message.blank? ? '': ', error_message: ' + message
      "#{self.class.to_s} : #{response.code} URI: #{@params[:uri]} #{error_message}"
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
