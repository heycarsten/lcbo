module LCBO
  module CrawlKit
    class Request

      attr_reader :request_prototype, :query_args, :body_params, :body

      def initialize(request_prototype, query_args = {}, body_params = {})
        self.request_prototype = request_prototype
        self.query_args = query_args
        self.body_params = body_params
      end

      def body_params=(value)
        @body_params = request_prototype.body_params.merge(value)
      end

      def config
        opts = {}
        opts[:method]     = request_prototype.http_method
        opts[:user_agent] = USER_AGENT
        opts[:params]     = body_params
        opts
      end

      def uri
        request_prototype.uri_template.expand(query_args).to_s
      end

      def request
        req = Typhoeus::Request.new(uri, config)
        req.on_complete do |response|
          ensure_success!
          @body = response.body.gsub("\r\n", "\n")
        end
        req
      end

      def perform
        Typhoeus::Hydra.hydra(request)
        Typhoeus::Hydra.hydra.run
        self
      end

      protected

      def ensure_success!
        return if request.response.code == 200
        raise RequestFailedError,
          "request on <#{uri}> failed with status: #{request.response.code}"
      end

    end
  end
end
