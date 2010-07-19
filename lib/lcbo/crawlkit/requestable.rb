module LCBO
  module CrawlKit
    module Requestable

      def self.included(mod)
        mod.send(:include, Eventable)
        mod.instance_variable_set(:@request_prototype, RequestPrototype.new)
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
      end

      def request(args = {}, params = {})
        fire :before_request
        @request_prototype.request(args, params)
        fire :after_request
      end

    end
  end
end
