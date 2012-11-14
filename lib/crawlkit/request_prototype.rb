# module LCBO
  module CrawlKit
    class RequestPrototype

      attr_reader :http_method, :uri_template, :body_params, :query_params

      def initialize(uri_template = nil, http_method = :get, body_params = {})
        self.uri_template = uri_template
        self.http_method  = http_method
        self.body_params  = body_params
      end

      def http_method=(value)
        @http_method = value ? value.to_s.downcase.to_sym : :get
      end

      def uri_template=(value)
        @uri_template = value
      end

      def body_params=(value)
        @body_params = value ? HashExt.symbolize_keys(value) : {}
      end

      def query_params=(value)
        @query_params = value ? HashExt.symbolize_keys(value) : {}
      end

      def request(query_params = {}, body_params = {})
        Request.new(self, query_params, body_params).run
      end

    end
  end
# end
