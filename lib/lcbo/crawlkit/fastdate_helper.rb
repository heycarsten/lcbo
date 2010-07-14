module LCBO
  module CrawlKit
    class FastDateHelper

      MONTH_NAMES_TO_NUMBERS = {
        'Jan' => '01',
        'Feb' => '02',
        'Mar' => '03',
        'Apr' => '04',
        'May' => '05',
        'Jun' => '06',
        'Jul' => '07',
        'Aug' => '08',
        'Sep' => '09',
        'Oct' => '10',
        'Nov' => '11',
        'Dec' => '12' }

      attr_reader :input

      def initialize(input_string)
        @input = input_string
      end

      def self.[](input_string)
        new(input_string).as_sql_date
      end

      def as_sql_date
        return nil unless input
        parts = input.gsub(',', '').split
        month = MONTH_NAMES_TO_NUMBERS[parts[0]]
        return nil unless month
        day = parts[1].rjust(2, '0')
        "#{parts[2]}-#{month}-#{day}"
      end

    end
  end
end
