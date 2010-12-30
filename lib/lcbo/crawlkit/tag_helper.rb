module LCBO
  module CrawlKit
    module TagHelper
      DELETION_RE   = /\'|\"|\\|\/|\(|\)|\[|\]|\./
      WHITESPACE_RE = /\*|\+|\&|\_|\,|\s/

      def self.flatten(values)
        TitleCaseHelper.downcase(values.flatten.join(' ')).
          gsub(DELETION_RE, '').
          gsub(WHITESPACE_RE, ' ').
          strip
      end

      def self.split(str)
        [str, str.to_ascii].
          join(' ').
          split.
          map { |word| stem(word) }.
          flatten.
          uniq
      end

      def self.stem(word)
        if word.include?('-')
          parts = word.split('-')
          a = parts.dup
          a << parts.join
          a
        else
          word
        end
      end

      def self.[](*values)
        return [] if values.any? { |val| '' == val.to_s.strip }
        split(flatten(values))
      end

    end
  end
end
