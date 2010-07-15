module LCBO
  module CrawlKit
    module Request

      def self.included(mod)
        mod.send(:attr_reader, :body)
        mod.send(:attr_reader, :params)
        mod.send(:include, Eventable)
        mod.extend(ClassMethods)
      end

      module ClassMethods
        def uri_template(tpl = nil)
          if tpl
            @uri_template = Addressable::Template.new(tpl)
            @args = @uri_template.variables
            @args.each do |arg|
              define_method(arg.to_s) { @params[arg.to_s] }
            end
          else
            @uri_template
          end
        end

        def body_params(proto = nil)
          proto ? @body_params = proto : @body_params
        end

        def parser(parser_class = nil)
          @parser_class ||= begin
            eval(self.name.sub('Request', 'Parser'))
          end
          parser_class ? @parser_class = parser_class : @parser_class
        end

        def parse(params = {})
          new(params).parse
        end
      end

      def initialize(params = {})
        @params = params.inject({}) { |h, (k, v)| h.merge(k.to_s => v) }
        @body = nil
        self.request!
      end

      def body_params
        (p = self.class.body_params) ? p.update(params) : nil
      end

      def requested?
        body ? true : false
      end

      def uri
        @uri ||= begin
          Addressable::URI.parse(
            self.class.uri_template.expand(params || {}).to_str)
        end
      end

      def parse
        self.class.parser.new(body, params)
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

      def request_options
        opts = {}
        opts[:method] = request_method
        opts[:user_agent] = user_agent
        opts[:params] = body_params.update(params) if post?
        opts
      end

      def request
        @request ||= begin
          req = Typhoeus::Request.new(uri.to_s, request_options)
          req.on_complete do |response|
            ensure_success!
            @body = response.body.gsub("\r\n", "\n")
          end
          req
        end
      end

      def user_agent
        @user_agent ||= begin
          LCBO.config[:user_agent] ||
          ENV['LCBO_USER_AGENT'] ||
          Typhoeus::USER_AGENT
        end
      end

      def enqueue_and_run_request
        hydra.queue(request)
        hydra.run
      end

      def request!
        return if requested?
        fire :before_request
        enqueue_and_run_request
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