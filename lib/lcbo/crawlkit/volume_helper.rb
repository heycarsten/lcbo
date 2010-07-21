module LCBO
  module CrawlKit
    class VolumeHelper

      attr_reader :package_volume, :unit_volume, :total_units, :unit_type

      def initialize(input)
        @input = input
        @package_volume = 0
        @unit_volume = 0
        @total_units = 0
        calculate
        self
      end

      def self.[](input_string)
        new(input_string).as_milliliters
      end

      def as_milliliters
        @package_volume
      end

      private

      def calculate
        return unless @input
        match = @input.match(/([0-9]+|[0-9]+x[0-9]+) (mL) ([a-z]+)/)
        return unless match
        captures = match.captures
        return unless captures.size == 3

        if captures[0].include?('x')
          @total_units, @unit_volume = *captures[0].split('x').map(&:to_i)
        else
          @total_units = 1
          @unit_volume = captures[0].to_i
        end

        @unit_type = captures[2]
        @package_volume = @total_units * @unit_volume
      end

    end
  end
end
