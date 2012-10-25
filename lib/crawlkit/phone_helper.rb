# module LCBO
  module CrawlKit
    module PhoneHelper

      def self.[](value)
        return if '' == value.to_s.strip
        m = value.gsub(/[^0-9]/, '')
        "(#{m[0,3]}) #{m[3,3]}-#{m[6,4]}"
      end

    end
  end
# end
