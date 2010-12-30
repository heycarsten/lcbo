require 'cgi'

module LCBO
  class StorePage

    include CrawlKit::Page

    uri 'http://www.lcbo.com/lcbo-ear/jsp/storeinfo.jsp?' \
        'STORE={store_no}&language=EN'

    DAY_NAMES = %w[
      monday
      tuesday
      wednesday
      thursday
      friday
      saturday
      sunday ]

    DETAIL_FIELDS = {
      :has_wheelchair_accessability => 'wheelchair',
      :has_bilingual_services       => 'bilingual',
      :has_product_consultant       => 'consultant',
      :has_tasting_bar              => 'tasting',
      :has_beer_cold_room           => 'cold',
      :has_special_occasion_permits => 'permits',
      :has_vintages_corner          => 'vintages',
      :has_parking                  => 'parking',
      :has_transit_access           => 'transit' }

    on :before_parse, :verify_store_returned
    on :after_parse,  :verify_node_count
    on :after_parse,  :verify_telephone_number

    emits :store_no do
      query_params[:store_no].to_i
    end

    emits :name do
      CrawlKit::TitleCaseHelper[info_nodes[1].content.strip]
    end

    emits :tags do
      CrawlKit::TagHelper[
        name,
        address_line_1,
        address_line_2,
        city,
        postal_code
      ]
    end

    emits :address_line_1 do
      data = info_nodes[2].content.strip.split(',')[0]
      unless data
        raise CrawlKit::MalformedError,
        "unable to locate address for store #{store_no}"
      end
      CrawlKit::TitleCaseHelper[data.gsub(/[\n\r\t]+/, ' ').strip]
    end

    emits :address_line_2 do
      data = info_nodes[2].content.strip.split(',')[1]
      CrawlKit::TitleCaseHelper[data.gsub(/[\n\r\t]+/, ' ').strip] if data
    end

    emits :city do
      data = info_nodes[3].content.strip.split(',')[0]
      CrawlKit::TitleCaseHelper[data.gsub(/[\n\r\t]+/, ' ').strip] if data
    end

    emits :postal_code do
      data = info_nodes[3].content.strip.split(',')[1]
      unless data
        raise CrawlKit::MalformedError,
        "unable to locate postal code for store #{store_no}"
      end
      data.gsub(/[\n\r\t]+/, ' ').strip.upcase
    end

    emits :telephone do
      info_nodes[4].content.
        gsub(/[\n\r\t]+/, ' ').
        gsub('Telephone:', '').
        strip
    end

    emits :fax do
      if has_fax?
        info_nodes[5].content.gsub(/[\n\r\t]+/, ' ').gsub('Fax:', '').strip
      end
    end

    emits :latitude do
      location['latitude'][0].to_f
    end

    emits :longitude do
      location['longitude'][0].to_f
    end

    DAY_NAMES.each do |day|
      emits :"#{day}_open" do
        time_open_close(day)[0]
      end

      emits :"#{day}_close" do
        time_open_close(day)[1]
      end
    end

    DETAIL_FIELDS.keys.each do |field|
      emits(field) { details[field] }
    end

    def detail_rows
      @detail_rows ||= begin
        doc.css('input[type="checkbox"]').map { |e| e.parent.parent.inner_html }
      end
    end

    def details
      @details ||= begin
        DETAIL_FIELDS.reduce({}) do |hsh, (field, term)|
          row   = detail_rows.detect { |row| row.include?(term) }
          value = row.include?('checked')
          hsh.merge(field => value)
        end
      end
    end

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
          open, close = *times.map { |time|
            hour, min = *time.split(':').map { |t| t.to_i }
            (hour * 60) + min
          }
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
      raise CrawlKit::NotFoundError, "store #{store_no} does not exist"
    end

    def verify_telephone_number
      return if telephone
      raise CrawlKit::MalformedError,
        "unable to locate telephone number for store #{store_no}"
    end

    def verify_node_count
      return if expected_node_count == info_nodes.size
      raise CrawlKit::MalformedError,
        "Expected #{expected_node_count} nodes for store #{store_no} but found " \
        "#{info_nodes.size} instead."
    end

  end
end
