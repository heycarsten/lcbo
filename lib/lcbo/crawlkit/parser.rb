module LCBO
  module CrawlKit
    class Parser

      attr_reader :body, :query_args, :body_params

      def initialize(body = nil, query_args = {}, body_params = {})
        @body = body
        @query_args = query_args
        @body_params = body_params
        @fields = []
      end

      def self.parse_response(response)
        new(response.body, response.query_args, response.body_params).parse
      end

      def emits(*args, &block)
        if block_given?
          emit(args[0], &block)
        else
          @fields.concat(args[0].is_a?(Array) ? args[0] : args)
        end
      end

      def emit(field, &block)
        @fields << field
        define_method(field, &block) if block_given?
      end

      def parse
        
      end

      def as_hash
        
      end

    end

    module Parser

      def self.included(mod)
        mod.send(:attr_reader, :html)
        mod.send(:attr_reader, :doc)
        mod.send(:attr_reader, :params)

        mod.extend(ClassMethods)
        mod.send(:include, Eventable)
      end

      module ClassMethods
        def from_request(request)
          new(request.body, request.params)
        end

        def from_json(json)
          request = Yajl::Parser.parse(json)
          symbolized_params = request['params'].reduce({}) { |h, (k, v)|
            h.merge(k.to_sym => v) }
          new(request['body'], symbolized_params)
        end

        def emits(*list)
          @emitters ||= []
          list.empty? ? @emitters : @emitters.concat(list)
        end
        alias_method :emitters, :emits
      end

      def initialize(html, params = {})
        @html = html
        @params = params.inject({}) { |h, (k, v)| h.merge(k.to_sym => v) }
        @doc = nil
        self.parse!
      end

      def parsed?
        doc ? true : false
      end

      def as_hash
        parse! unless parsed?
        self.class.emitters.inject({}) do |hsh, key|
          hsh.merge(key.to_sym => self.send(key.to_sym))
        end
      end

      protected

      def parse!
        return if parsed?
        fire :before_parse
        @doc = Nokogiri::HTML(html)
        fire :after_parse
      end

    end
  end
end
