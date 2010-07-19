module LCBO
  module CrawlKit
    module Parseable

      def self.included(mod)
        mod.include(Eventable)
        mod.instance_variable_set(:@fields, [])
        mod.extend(ClassMethods)
      end

      module ClassMethods
        def self.emits(field, &block)
          @fields << field.to_sym
          define_method(field, &block) if block_given?
        end
      end

    end
  end
end
