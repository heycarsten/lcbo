module LCBO
  module CrawlKit
    class RequestPrototype

      attr_reader :http_method, :uri_template, :body_params

      def initialize(uri_template = nil, http_method = :get, body_params = {})
        self.uri_template = uri_template
        self.http_method  = http_method
        self.body_params  = body_params
      end

      def http_method=(value)
        @http_method = value.to_s.downcase.to_sym
      end

      def uri_template=(value)
        @uri_template = Addressable::Template.new(value)
      end

      def body_params=(value)
        @body_params = HashExt.symbolize_keys(value)
      end

      def request(args = {}, params = {})
        Request.new(self, args, params).perform
      end

    end
  end
end
