module LCBO
  module CrawlKit
    module Eventable

      EVENT_TYPES = %[
        before_request
        after_request
        before_parse
        after_parse ]

      def self.included(mod)
        mod.extend(ClassMethods)
      end

      def fire(event_type)
        self.class.callbacks.
          select { |callback| callback.is_for?(event_type) }.
          each   { |callback| callback.call_on(self) }
      end

      module ClassMethods
        def on(event_type, *method_names)
          @callbacks ||= []
          method_names.each do |method_name|
            @callbacks << Callback.new(event_type, method_name)
          end
        end

        def callbacks
          @callbacks || []
        end
      end

      class Callback
        attr_reader :event_type, :method_name

        def initialize(event_type, method_name)
          @event_type = event_type.to_sym
          @method_name = method_name.to_sym
        end

        def is_for?(event_sym)
          unless EVENT_TYPES.include?(event_sym.to_s)
            raise ArgumentError, "event_type: #{event_sym} is not valid"
          end
          event_type == event_sym.to_sym
        end

        def call_on(object)
          object.send(method_name)
        end
      end

    end
  end
end
