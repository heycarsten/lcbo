module LCBO
  module CrawlKit
    class RequestPrototype

      attr_reader :http_method, :uri_template, :params

      def initialize(uri_template = nil, http_method = :get, params = {})
        self.uri_template = uri_template
        self.http_method  = http_method
        self.params       = params
      end

      def http_method=(value)
        @http_method = value ? value.to_s.downcase.to_sym : :get
      end

      def uri_template=(value)
        @uri_template = Addressable::Template.new(value) if value
      end

      def params=(value)
        @params = value ? HashExt.symbolize_keys(value) : {}
      end

      def request(args = {}, params = {})
        Request.new(self, args, params).perform
      end

    end
  end
end
