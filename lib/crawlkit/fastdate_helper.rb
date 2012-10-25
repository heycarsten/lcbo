# module LCBO
  module CrawlKit
    class FastDateHelper

      MONTH_NAMES_TO_NUMBERS = {
        'Jan' => 1,
        'Feb' => 2,
        'Mar' => 3,
        'Apr' => 4,
        'May' => 5,
        'Jun' => 6,
        'Jul' => 7,
        'Aug' => 8,
        'Sep' => 9,
        'Oct' => 10,
        'Nov' => 11,
        'Dec' => 12 }

      def self.[](input)
        return nil unless input
        parts = input.gsub(',', '').split
        month = MONTH_NAMES_TO_NUMBERS[parts[0]]
        return nil unless month
        Date.new(parts[2].to_i, month, parts[1].to_i)
      end

    end
  end
# end
