module LCBO
  module CrawlKit
    module TagHelper
      DELETION_RE   = /\"|\\|\/|\(|\)|\[|\]|\./
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
        split = lambda { |word|
          if word.include?('-')
            words = word.split('-')
            a = words.dup
            a << word
            a << words.join
            a
          else
            [word]
          end
        }

        tokenize = lambda { |words|
          words.reduce([]) do |tokens, word|
            tokens << word
            tokens << word.gsub("'", '') if word.include?("'")
            tokens
          end
        }

        tokenize.(split.(word))
      end

      def self.[](*values)
        return [] if values.all? { |val| '' == val.to_s.strip }
        split(flatten(values))
      end

    end
  end
end
