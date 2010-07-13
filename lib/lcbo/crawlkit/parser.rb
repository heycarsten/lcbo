module LCBO
  module CrawlKit
    module Parser

      def self.included(mod)
        mod.send(:attr_reader, :html)
        mod.send(:attr_reader, :doc)
        mod.send(:attr_reader, :params)

        mod.extend(ClassMethods)
        mod.send(:include, Errors)
        mod.send(:include, Eventable)
      end

      module ClassMethods
        def from_request(request)
          new(request.body, request.params)
        end

        def from_json(json)
          request = Yajl.parse(json)
          parse(req['body'], request['params'].
            inject({}) { |h, (k, v)| h.merge(k.to_sym => v) })
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
