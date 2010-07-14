require 'cgi'

module LCBO
  class StoreParser

    include CrawlKit::Parser

    DAY_NAMES = %w[
      monday
      tuesday
      wednesday
      thursday
      friday
      saturday
      sunday ]

    on :before_parse, :verify_store_returned
    on :after_parse,  :verify_node_count
    on :after_parse,  :verify_telephone_number

    emits \
      :store_no,
      :name,
      :address_line_1,
      :address_line_2,
      :city,
      :postal_code,
      :telephone,
      :fax,
      :latitude,
      :longitude

    def store_no
      params[:store_no].to_i
    end

    DAY_NAMES.each do |day|
      emits :"#{day}_open", :"#{day}_close"

      define_method "#{day}_open" do
        time_open_close(day)[0]
      end

      define_method "#{day}_close" do
        time_open_close(day)[1]
      end
    end

    def name
      TitleCaseHelper[info_nodes[1].content.strip]
    end

    def address_line_1
      data = info_nodes[2].content.strip.split(',')[0]
      unless data
        raise MalformedDocumentError,
          "unable to locate address for store #{store_no}"
      end
      CrawlKit::TitleCaseHelper[data.gsub(/[\n\r\t]+/, ' ').strip]
    end

    def address_line_2
      data = info_nodes[2].content.strip.split(',')[1]
      return unless data
      CrawlKit::TitleCaseHelper[data.gsub(/[\n\r\t]+/, ' ').strip]
    end

    def city
      data = info_nodes[3].content.strip.split(',')[0]
      return unless data
      CrawlKit::TitleCaseHelper[data.gsub(/[\n\r\t]+/, ' ').strip]
    end

    def postal_code
      data = info_nodes[3].content.strip.split(',')[1]
      unless data
        raise MalformedDocumentError,
        "unable to locate postal code for store #{store_no}"
      end
      data.gsub(/[\n\r\t]+/, ' ').strip.upcase
    end

    def telephone
      info_nodes[4].content.
        gsub(/[\n\r\t]+/, ' ').
        gsub('Telephone:', '').
        strip
    end

    def fax
      return unless has_fax?
      info_nodes[5].content.
        gsub(/[\n\r\t]+/, ' ').
        gsub('Fax:', '').
        strip
    end

    def latitude
      location['latitude'][0].to_f
    end

    def longitude
      location['longitude'][0].to_f
    end

    protected

    def map_anchor_href
      info_nodes[has_fax? ? 6 : 5].css('a').first.attributes['href'].to_s
    end

    def location
      CGI.parse(URI.parse(map_anchor_href).query)
    end

    def has_fax?
      info_nodes.to_s.include?('Fax: ')
    end

    def time_open_close(day)
      open_close_times[day.to_s.downcase]
    end

    def open_close_times
      @open_close_times ||= begin
        time_cells.inject({}) do |hsh, td|
          text = td.text.gsub(/\s+/, ' ')
          day = text.match(/[MTWTFS]{1}[a-z]+/).to_s.downcase
          times = text.scan(/[0-9]{1,2}:[0-9]{2}/)
          open, close = *times.map do |time|
            hour, min = *time.split(':').map { |t| t.to_i }
            (hour * 60) + min
          end
          hsh.merge(day => (open == close ? [nil, nil] : [open, close]))
        end
      end
    end

    def container_table
      @doc.css('table.border[width="478"]')
    end

    def hours_table
      container_table.css('table[width="100%"]')
    end

    def info_nodes
      container_table.css('td[width="48%"]')
    end

    def time_cells
      hours_table.
        css('td[width="50%"] tr').
        select { |td| td.to_s =~ /[MTWTFS]{1}[onuesdhriat]{2,5}day/ }
    end

    def expected_node_count
      has_fax? ? 8 : 7
    end

    def verify_store_returned
      return if !@html.include?('No stores were located using your criteria.')
      raise MissingResourceError, "store #{store_no} does not exist"
    end

    def verify_telephone_number
      return if telephone
      raise MalformedDocumentError,
        "unable to locate telephone number for store #{store_no}"
    end

    def verify_node_count
      return if expected_node_count == info_nodes.size
      raise MalformedDocumentError,
        "Expected #{expected_node_count} nodes for store #{store_no} but found " \
        "#{info_nodes.size} instead."
    end

  end
end
