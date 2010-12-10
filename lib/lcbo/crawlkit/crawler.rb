module LCBO
  module CrawlKit
    module Crawler

      MAX_RETRIES = 8

      class NotImplementedError < StandardError; end

      def self.included(host)
        host.extend(ClassMethods)
        host.instance_eval { include InstanceMethods }
      end

      module ClassMethods
        def run(params = {}, &emitter)
          crawler = new(&emitter)
          result  = crawler.run(params)
          crawler.respond_to?(:reduce) ? crawler.reduce : result
        end
      end

      module InstanceMethods
        attr_reader :responses

        def initialize(&emitter)
          @emitter = emitter
          @responses = []
        end

        def run(params = {})
          case
          when params.is_a?(Array) && params.any?
            runeach(params)
          when respond_to?(:pop)
            runpop
          when respond_to?(:enum)
            runeach(enum)
          else
            _request(params)
          end
        end

        def failure(error, params)
          raise error
        end

        def continue?(response)
          false
        end

        def request(params = {})
          raise NotImplementedError, "#{self.class} must implement #request"
        end

        protected

        def runpop
          while (params = pop)
            _request(params)
          end
        end

        def runeach(params)
          params.each { |p| _request(p) }
        end

        def _request(params = {})
          response = request(params)
          @responses << response if respond_to?(:reduce)
          @emitter.(response) if @emitter
          continue?(response) ? run(response) : response
        rescue => error
          failure(error, params)
        end
      end

    end
  end
end
