module LCBO
  module CrawlKit
    class Request

      attr_reader :request_prototype, :query, :params

      def initialize(request_prototype, query = {}, params = {})
        @request_prototype = request_prototype
        @query             = query
        self.params        = params
      end

      def params=(value)
        @params = request_prototype.params.merge(value || {})
      end

      def config
        opts = {}
        opts[:method]     = request_prototype.http_method
        opts[:user_agent] = USER_AGENT
        opts[:params]     = params
        opts
      end

      def uri
        request_prototype.uri_template.expand(query).to_s
      end

      def run
        response = Typhoeus::Request.run(uri, config)
        Response.new(response, query, params)
      end

    end
  end
end
