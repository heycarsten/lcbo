# coding: utf-8
# TODO: This is an ugly piece of ass that should burn and die!
module LCBO
  module CrawlKit
    class TitleCaseHelper

      UPPER_CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝ'
      LOWER_CHARS = 'abcdefghijklmnopqrstuvwxyzàáâãäåæçèéêëìíîïðñòóôõöøùúûüý'
      ALPHA_RANGE = "[#{UPPER_CHARS}#{LOWER_CHARS}]"
      UPPER_RANGE = "[#{UPPER_CHARS}]"
      LOWER_RANGE = "[#{LOWER_CHARS}]"
      FIRST_CHAR_RE = /#{ALPHA_RANGE}{1}/u
      ALPHA_RE = /#{ALPHA_RANGE}.*/u
      SMALL_WORDS = %w[ a an and as at but by en for if in of del de on or the to v v. via vs vs. ]
      ACRONYMS = %w[ vqa vsop xo nq5 vs xxx igt xiii xi xoxo srl bdb cvbg ocb lcbo i ii iii ]

      attr_reader :input

      def self.[](string)
        titleize(string)
      end

      def self.upcase(string)
        string.tr(LOWER_CHARS, UPPER_CHARS)
      end

      def self.downcase(string)
        string.tr(UPPER_CHARS, LOWER_CHARS)
      end

      def self.preclean(string)
        # Strip useless bracketed crap: Some Product Name (Some Redundant Stuff)**
        string.gsub(/\(.+\Z/, '').
        # Strip trailing stars.
        gsub(/\*+\Z/, '')
      end

      def self.capitalize(string)
        first_letter = string.scan(FIRST_CHAR_RE)[0]
        if first_letter
          uchar = upcase(first_letter)
          string.sub(/#{first_letter}/u, uchar)
        else
          string
        end
      end

      def self.titleize(string)
        phrases(preclean(downcase(string))).map do |phrase|
          words = phrase.split
          words.map do |word|
            def word.capitalize
              self.sub(ALPHA_RE) { |subword| TitleCaseHelper.capitalize(subword) }
            end
            case word
            when *(ACRONYMS + ACRONYMS.map { |ac| capitalize(ac) })
              upcase(word)
            when /#{ALPHA_RANGE}\&#{ALPHA_RANGE}/u # words with &, like E&J
              word.split(/\&/).map { |w| capitalize(w) }.join('&')
            when /#{ALPHA_RANGE}\-#{ALPHA_RANGE}/u # words with dashes, like "Smith-Weston"
              word.split(/\-/).map { |w| capitalize(w) }.join('-')
            when /#{ALPHA_RANGE}\/#{ALPHA_RANGE}/u # words with slashes
              word.split(/\//).map { |w| capitalize(w) }.join(' / ')
            when /#{ALPHA_RANGE}\.#{ALPHA_RANGE}/u # words with dots, like "example.com"
              capitalized = word.split(/\./u).map { |w| capitalize(w) }.join('.')
              '.' == word[-1, 1] ? capitalized + '.' : capitalized
            when /^#{ALPHA_RANGE}.*#{UPPER_RANGE}/u # non-first letter capitalized already
              word
            when words.first, words.last
              word.capitalize
            when *(SMALL_WORDS + SMALL_WORDS.map { |small| capitalize(small) })
              word.downcase
            else
              word.capitalize
            end
          end.join(' ')
        end.join(' ').
        # Special case for Word'S
        gsub(/(['’])S\b/, '\1s')
      end

      def self.phrases(title)
        phrases = title.scan(/.+?(?:[:.;?!] |$)/u).map { |phrase| phrase.strip }
        # rejoin phrases that were split on the '.' from a small word
        if phrases.size > 1
          phrases[0..-2].each_with_index do |phrase, index|
            if SMALL_WORDS.include?(phrase.split.last.downcase)
              phrases[index] << " " + phrases.slice!(index + 1)
            end
          end
        end
        phrases
      end

    end
  end
end
