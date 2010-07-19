module LCBO
  module CrawlKit
    module Page

      def self.included(mod)
        mod.include(Eventable)
        mod.instance_variable_set(:@request_prototype, RequestPrototype.new)
        mod.instance_variable_set(:@fields, [])
        mod.extend(ClassMethods)
      end

      module ClassMethods
        def uri_template(value)
          @request_prototype.uri_template = value
        end

        def body_params(value)
          @request_prototype.body_params = value
        end

        def http_method(value)
          @request_prototype.http_method = value
        end

        def self.emits(field, &block)
          @fields << field.to_sym
          define_method(field, &block) if block_given?
        end
      end

      def parse(args = {}, params = {})
        response = request(args, params)
        fire :before_parse
        @parser.parse(response, fields)
        fire :after_parse
      end

      def request(args = {}, params = {})
        fire :before_request
        @request_prototype.request(args, params)
        fire :after_request
      end

    end
  end
end
