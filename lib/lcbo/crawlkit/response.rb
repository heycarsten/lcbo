module LCBO
  module CrawlKit
    class Response

      attr_reader :response, :body, :query_params, :body_params, :uri,
        :code, :time

      def initialize(response, query_params, body_params)
        @response     = response
        @code         = response.code
        @uri          = response.request.url
        @http_method  = response.request.method
        @time         = response.time
        @query_params = query_params
        @body_params  = body_params
        @body         = self.class.normalize_encoding(response.body)
        ensure_success!
      end

      def self.normalize_encoding(html)
        if html.valid_encoding?
          html
        else
          html.force_encoding('ISO-8859-1')
          html.encode('UTF-8')
        end.gsub("\r\n", "\n")
      end

      protected

      def ensure_success!
        return if @code == 200
        raise RequestFailedError, "<#{@uri}> failed with status: #{@code}"
      end

    end
  end
end
