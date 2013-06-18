# module LCBO
  module CrawlKit
    class Response

      attr_reader :response, :body, :query_params, :body_params, :uri,
        :code, :time, :http_method

      def initialize(response)
        params        = HashExt.symbolize_keys(response)
        @code         = params[:code]
        @uri          = params[:uri]
        @http_method  = params[:http_method]
        @time         = params[:time]
        @query_params = params[:query_params]
        @body_params  = params[:body_params]
        @body         = self.class.normalize_encoding(params[:body])
        ensure_success!
      end

      def self.normalize_encoding(html)
        html.force_encoding('UTF-8').gsub("\r\n", "\n")
        # if html.force_encoding('ISO-8859-1').valid_encoding?
        #   html.encode('UTF-8', 'ISO-8859-1')
        # else
        #   html.encode('UTF-8')
        # end.gsub("\r\n", "\n")
      end

      def as_hash
        { :code         => code,
          :uri          => uri,
          :http_method  => http_method,
          :time         => time,
          :query_params => query_params,
          :body_params  => body_params,
          :body         => body }
      end

      protected

      def ensure_success!
        return if @code == 200
        raise RedirectedError, "<#{@uri}> returned status 302" if @code == 302
        raise RequestFailedError, "<#{@uri}> failed with status: #{@code}"
      end

    end
  end
# end
