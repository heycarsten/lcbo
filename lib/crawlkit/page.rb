# module LCBO
  module CrawlKit
    module Page

      def self.included(mod)
        mod.module_eval do
          include Eventable
          attr_reader :html, :query_params, :body_params, :response
          instance_variable_set :@request_prototype, RequestPrototype.new
          instance_variable_set :@fields, []
        end
        mod.extend(ClassMethods)
      end

      module ClassMethods
        def uri(value = nil)
          if value
            @request_prototype.uri_template = value
          else
            @request_prototype.uri_template
          end
        end

        def default_body_params(value = nil)
          if value
            @request_prototype.body_params = value
          else
            @request_prototype.body_params
          end
        end

        def http_method(value = nil)
          if value
            @request_prototype.http_method = value
          else
            @request_prototype.http_method
          end
        end

        def emits(field, &block)
          fields << field.to_sym
          define_method(field) { instance_exec(field, &block) } if block_given?
        end

        def request(query_params = {}, body_params = {})
          new(query_params, body_params).request
        end

        def parse(response)
          new(nil, nil, response).parse
        end

        def process(query_params = {}, body_params = {})
          new(query_params, body_params).process
        end

        def fields
          @fields
        end

        def request_prototype
          @request_prototype
        end
      end

      def initialize(query_params = {}, body_params = {}, response = nil)
        if response
          @response     = response.is_a?(Hash) ? Response.new(response) : response
          @query_params = @response.query_params
          @body_params  = @response.body_params
          @html         = @response.body
        else
          @query_params = query_params
          @body_params  = body_params
        end
      end

      def [](field)
        as_hash[field.to_sym]
      end

      def request_prototype
        self.class.request_prototype
      end

      def fields
        self.class.fields
      end

      def http_method
        self.class.http_method
      end

      def process
        request
        parse
        self
      end

      def request
        return if @html
        fire :before_request
        @response = request_prototype.request(query_params, body_params)
        @html     = @response.body

        # puts @response, @html
        fire :after_request
        self
      end

      def parse
        return if is_parsed?
        return unless @html
        fire :before_parse
        @doc = Nokogiri::HTML(@html)
        fire :after_parse
        self
      end

      def is_parsed?
        doc ? true : false
      end

      def as_hash
        @as_hash ||= Hash[fields.map { |field| [field, send(field)] }]
      end

      protected

      def doc
        @doc
      end

    end
  end
# end
