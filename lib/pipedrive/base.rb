module Pipedrive
  class Base
    def initialize(api_token = ::Pipedrive.api_token)
      fail 'api_token should be set' unless api_token.present?
      @api_token = api_token
    end

    def connection
      self.class.connection.dup
    end

    def make_api_call(*args)
      params = args.extract_options!
      method = args[0]
      fail 'method param missing' unless method.present?
      res = connection.__send__(method.to_sym, build_url(args), params)
      process_response(res)
    end

    def build_url(args)
      url = entity_name
      url << "/#{args[1]}" if args[1]
      url << "?api_token=#{@api_token}"
      url
    end

    def process_response(res)
      if res.success?
        data = if res.body.is_a?(::Hashie::Mash)
                 res.body.merge(success: true)
               else
                 ::Hashie::Mash.new(success: true)
               end
        return data
      end
      failed_response(res)
    end

    def failed_response(res)
      failed_res = res.body.merge(success: false, not_authorized: false,
                                  failed: false)
      case res.status
      when 401
        failed_res.merge! not_authorized: true
      when 420
        failed_res.merge! failed: true
      end
      failed_res
    end

    def entity_name
      self.class.name.split('::')[-1].downcase.pluralize
    end

    class << self
      def faraday_options
        {
          url:     'https://api.pipedrive.com/v1',
          headers: {
            accept:     'application/json',
            user_agent: ::Pipedrive.user_agent
          }
        }
      end

      # This method smells of :reek:TooManyStatements
      def connection # :nodoc
        @connection ||= Faraday.new(faraday_options) do |conn|
          conn.request :url_encoded
          conn.response :mashify
          conn.response :json, content_type: /\bjson$/
          conn.adapter Faraday.default_adapter
          conn.use FaradayMiddleware::ParseJson
          conn.response :logger, ::Pipedrive.logger if ::Pipedrive.debug
        end
      end
    end
  end
end