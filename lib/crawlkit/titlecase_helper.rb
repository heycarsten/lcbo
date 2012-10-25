# coding: utf-8
# module LCBO
  module CrawlKit
    class TitleCaseHelper

      SMALL_WORDS = %w[
        a an and as at but by en for if in of del de on or the to v v. via
        vs.
      ]

      ACRONYMS = %w[
        i ii iii iv v vi vii viii ix x xiii xi vqa vsop xo nq5 vs xxx igt xoxo
        srl bdb cvbg ocb lcbo gtm hf yo vs ipa
      ]

      attr_reader :input

      def self.[](string)
        titlecase(string)
      end

      def self.upcase(string)
        UnicodeUtils.simple_upcase(string)
      end

      def self.downcase(string)
        UnicodeUtils.simple_downcase(string)
      end

      def self.capitalize(string)
        UnicodeUtils.titlecase(string)
      end

      def self.titlecase(string)
        preclean = lambda { |s|
          # Strip bracketed stuff and trailing junk: Product (Junk)**
          s.gsub(/\((.+?)\)|\*+|\((.+?)\Z/, '').strip
        }
        count = 0 # Ewwww
        capitalize(preclean.(string)).split.map do |word|
          count += 1
          case word.downcase
          when /[\w]\/[\w]/ # words with slashes
            word.split('/').map { |w| capitalize(w) }.join(' / ')
          when /[\w]\&[\w]/ # words with &, like E&J
            word.split('&').map { |w| capitalize(w) }.join('&')
          when /[\w]\-[\w]/ # words with dashes, like "Super-Cool"
            word.split('-').map { |w| capitalize(w) }.join('-')
          when /[\w]\.[\w]/ # words with dots, like "A.B.C."
            word.split('.').map { |w| upcase(w) }.join('.') + '.'
          when *SMALL_WORDS
            1 == count ? word : word.downcase
          when *ACRONYMS
            word.upcase
          else
            word
          end
        end.
        join(' ').
        gsub(/(['’])S\b/, '\1s'). # Word'S => Word's
        gsub(/(\S{1})'(\S{2,})/u) { "#{$1}'#{capitalize $2}" } # D'aux => D'Aux
      end

    end
  end
# end
