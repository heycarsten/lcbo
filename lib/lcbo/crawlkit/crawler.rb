module LCBO
  module CrawlKit
    module Crawler

      def self.included(mod)
        mod.module_eval { attr_reader :active_crawl }
        mod.send(:include, Errors)
        mod.send(:include, Eventable)
        mod.extend(ClassMethods)
      end

      module ClassMethods
      end

      def initialize
        @active_crawl = Crawl.current_working_crawl
      end

      protected

      def request_method
        body_params ? :post : :get
      end

      def post?
        :post == request_method
      end

      def hydra
        Typhoeus::Hydra.hydra
      end

      def request
        @request ||= begin
          opts = {}
          opts[:method] = request_method
          opts[:user_agent] = user_agent
          opts[:params] = body_params.update(params) if post?
          req = Typhoeus::Request.new(uri.to_s, opts)
          req.on_complete do |response|
            ensure_success!
            @body = response.body.gsub("\r\n", "\n")
          end
          req
        end
      end

      def user_agent
        @user_agent ||= begin
          LCBO.config[:crawlkit][:user_agent] || Typhoeus::USER_AGENT
        end
      end

      def request!
        return if requested?
        fire :before_request
        hydra.queue(request)
        hydra.run
        fire :after_request
      end

      def ensure_success!
        return if request.response.code == 200
        raise RequestFailedError,
          "request on <#{uri.to_s}> failed with status: #{request.response.code}"
      end

    end
  end
end
