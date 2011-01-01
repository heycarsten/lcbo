module LCBO
  module CrawlKit
    module CaptionHelper

      def self.[](value)
        return if '' == value.to_s.strip
        caption = normalize_whitespace(strip_html(value))
        '' == caption ? nil : caption
      end

      def self.normalize_whitespace(value)
        value.gsub(/\s+/, ' ').strip
      end

      def self.strip_html(value)
        value.gsub(/\<.+?\>/, '')
      end

    end
  end
end
