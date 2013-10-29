# module LCBO
  module CrawlKit
    class Request

      MAX_RETRIES = 3

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
        opts[:method]  = request_prototype.http_method
        opts[:headers] = { 'User-Agent' => USER_AGENT, 'Content-Type' => "text/xml; charset=utf-8" }
        opts[:body]    = _body if body_params && !gettable?
        opts[:params]  = query_params if query_params && !gettable?
        opts
      end

      def uri
        template = request_prototype.uri_template.dup
        query_params.reduce(template) do |mem, (key, value)|
          mem.gsub("{#{key}}", value.to_s)
        end
      end

      def run
        _run
      end

    protected

      def _body
        traversal = Typhoeus::Utils.traverse_params_hash(body_params)
        Typhoeus::Utils.traversal_to_param_string(traversal)
      end

      def _run(tries = 0)
        response = Timeout.timeout(LCBO.config[:timeout]) do
          Typhoeus::Request.new(uri, config).run
        end
        Response.new \
          :code         => response.code,
          :uri          => response.request.url,
          :http_method  => response.request.options[:method],
          :time         => response.time,
          :query_params => query_params,
          :body_params  => body_params,
          :body         => response.body
      rescue Errno::ETIMEDOUT, Timeout::Error
        if tries > LCBO.config[:max_retries]
          raise TimeoutError, "Request failed after timing out #{tries} times"
        end
        _run(tries + 1)
      end

    end
  end
# end
