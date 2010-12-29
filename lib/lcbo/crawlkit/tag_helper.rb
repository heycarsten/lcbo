module LCBO
  module CrawlKit
    class TagHelper

      def self.[](value)
        return [] unless value && value.to_s.strip != ''
        TitleCaseHelper.downcase(value).split.reduce([]) do |tags, word|
          tags << word
          tags << word.to_ascii
        end.uniq.join(' ')
      end

    end
  end
end
