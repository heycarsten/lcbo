require 'cgi'

module BCL
  class StorePage

    include CrawlKit::Page

    # uri 'http://www.lcbo.com/lcbo-ear/jsp/storeinfo.jsp?STORE={id}&language=EN'
    uri 'http://www.bcliquorstores.com/store/{id}'

    FEATURE_FIELDS = {
      :has_wheelchair_accessability => 'wheelchair',
      :has_bilingual_services       => 'bilingual',
      :has_product_consultant       => 'consultant',
      :has_tasting_bar              => 'tasting',
      :has_beer_cold_room           => 'cold',
      :has_special_occasion_permits => 'permits',
      :has_vintages_corner          => 'corner',
      :has_parking                  => 'parking',
      :has_transit_access           => 'transit' }

    # on :before_parse, :verify_store_returned
    # on :after_parse,  :verify_telephone_number

    emits :id do
      query_params[:id].to_i
    end

    emits :name do
      # CrawlKit::TitleCaseHelper[doc.css('.infoWindowTitle')[0].content.strip]
      CrawlKit::TitleCaseHelper[doc.css('title')[0].content.split("|")[0].strip]
    end

    # emits :tags do
    #   CrawlKit::TagHelper[
    #     name,
    #     address_line_1,
    #     address_line_2,
    #     city,
    #     postal_code
    #   ]
    # end

    emits :address_line_1 do
      data = doc.css('.storeStreet').first.content.strip
      # data = CrawlKit::TitleCaseHelper[doc.css('.storeStreet')[0].content.strip]
      # unless data
      #   raise CrawlKit::MalformedError,
      #   "unable to locate address for store #{id}"
      # end
      # CrawlKit::TitleCaseHelper[data.gsub(/[\n\r\t]+/, ' ').strip]
    end

    emits :address_line_2 do
      data = doc.css('.storeAdditional').first.content.strip rescue nil
      # data = CrawlKit::TitleCaseHelper[doc.css('.storeAdditional')[0].content.strip]
      # unless data
      #   raise CrawlKit::MalformedError,
      #   "unable to locate address for store #{id}"
      # end
      # data
    end

    emits :city do
      CrawlKit::TitleCaseHelper[doc.css('.storeCity')[0].content.split(",")[0].strip]
    end

    emits :postal_code do
      data = CrawlKit::TitleCaseHelper[doc.css('.storeCity')[0].content.split(", BC")[1].strip]
      unless data
        raise CrawlKit::MalformedError,
        "unable to locate postal code for store #{id}"
      end
      data.strip.upcase
    end

    emits :telephone do
      CrawlKit::PhoneHelper[doc.css('.storePhoneNumber')[0].content.strip]
    end

    # emits :fax do
    #   if has_fax?
    #     pos = (info_nodes_count - 1)
    #     CrawlKit::PhoneHelper[
    #       info_nodes[pos].content.sub('Fax:', '').strip
    #     ]
    #   end
    # end

    # emits :latitude do
    #   node = doc.css('#latitude').first
    #   node ? node[:value].to_f : nil
    # end

    # emits :longitude do
    #   node = doc.css('#longitude').first
    #   node ? node[:value].to_f : nil
    # end

    # Date::DAYNAMES.map { |d| d.downcase }.each do |day|
    #   emits :"#{day}_open" do
    #     open_close_times[day.downcase][0]
    #   end

    #   emits :"#{day}_close" do
    #     open_close_times[day.downcase][1]
    #   end
    # end

    # FEATURE_FIELDS.keys.each do |field|
    #   emits(field) { features[field] }
    # end

    def get_info_node_offset(index)
      pos = (info_nodes_count == 9 ? index : index + 1)
      pos += (info_nodes_count == 9 ? 1 : -1) unless has_fax?
      pos
    end

    def feature_cells
      @feature_cells ||= begin
        doc.css('input[type="checkbox"]').map { |el| el.parent.inner_html }
      end
    end

    def features
      @details ||= begin
        Hash[FEATURE_FIELDS.map { |field, term|
          cell = feature_cells.detect { |cell| cell.include?(term) }
          value = cell.include?('checked')
          [field, value]
        }]
      end
    end

    def has_fax?
      info_nodes.to_s.include?('Fax:')
    end

    def open_close_times
      @open_close_times ||= begin
        days = Date::DAYNAMES.map { |d| d.downcase }
        Hash[days.each_with_index.map { |day, idx|
          text = doc.css("#row#{idx}Time.hours")[0].content
          next [day, [nil, nil]] if text.include?('Closed')
          times = text.split('-')
          open, close = *times.map { |time|
            ord = time.include?('PM') ? 12 : 0
            hour, min = *time.sub(/AM|PM/, '').strip.split(':').map { |t| t.to_i }
            hour += ord
            (hour * 60) + min
          }
          [day, (open == close ? [nil, nil] : [open, close])]
        }]
      end
    end

    def info_nodes_count
      info_nodes.size
    end

    def info_nodes
      doc.css('#storeDetails td.main_font')
    end

    def verify_store_returned
      return if !@html.include?('No stores were located using your criteria.')
      raise CrawlKit::NotFoundError, "store #{id} does not exist"
    end

    def verify_telephone_number
      return if telephone
      raise CrawlKit::MalformedError,
        "unable to locate telephone number for store #{id}"
    end

  end
end
