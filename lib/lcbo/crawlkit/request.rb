module LCBO
  module CrawlKit
    class Request

      attr_reader :request_prototype, :query_params, :body_params

      def initialize(request_prototype, query_p = {}, body_p = {})
        @request_prototype = request_prototype
        self.query_params  = query_p
        self.body_params   = body_p
      end

      def query_params=(value)
        @query_params = (value || {})
      end

      def body_params=(value)
        @body_params = request_prototype.body_params.merge(value || {})
      end

      def gettable?
        [:head, :get].include?(request_prototype.http_method)
      end

      def config
        opts = {}
        opts[:method]     = request_prototype.http_method
        opts[:user_agent] = USER_AGENT
        opts[:params]     = body_params unless gettable?
        opts
      end

      def uri
        request_prototype.uri_template.expand(query_params).to_s
      end

      def run
        response = Typhoeus::Request.run(uri, config)
        Response.new \
          :code         => response.code,
          :uri          => response.request.url,
          :http_method  => response.request.method,
          :time         => response.time,
          :query_params => query_params,
          :body_params  => body_params,
          :body         => response.body
      end

    end
  end
end
