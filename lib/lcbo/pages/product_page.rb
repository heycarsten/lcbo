module LCBO
  class ProductPage

    include CrawlKit::Page

    # uri 'http://lcbo.com/lcbo-ear/lcbo/product/details.do?language=EN&itemNumber={id}'
    uri 'http://www.lcbo.ca/lcbo/product/name/{id}'

    # on :before_parse, :verify_response_not_blank
    # on :after_parse,  :verify_product_details_form
    # on :after_parse,  :verify_product_name
    # on :after_parse,  :verify_third_info_cell

    emits :id do
      query_params[:id].to_i
    end

    emits :name do
      CrawlKit::TitleCaseHelper[doc.css('.details h1')[0].content]
    end

    emits :tags do
      # CrawlKit::TagHelper[
      #   name,
      #   primary_category,
      #   secondary_category,
      #   origin,
      #   producer_name,
      #   package_unit_type
      # ]
    end

    emits :price_in_cents do
      data = doc.css('.prices strong')[0].content.gsub(/(\$|,)/,'').strip.to_f * 100 rescue 0
      result = data.round
    end

    emits :sale_price_in_cents do
      if has_limited_time_offer
        price_in_cents
      else
        0
      end
    end

    emits :regular_price_in_cents do
      if has_limited_time_offer
        data = doc.css('.prices small')[0].content.gsub(/WAS.?\$/i,'').gsub(',','').strip.to_f * 100 rescue 0
        result = data.round
      else
        price_in_cents
      end
    end

    emits :limited_time_offer_savings_in_cents do
      regular_price_in_cents - price_in_cents
    end

    emits :limited_time_offer_ends_on do
      if has_limited_time_offer
        x = doc.css('.lto-end-date')[0].content.match(/Until ([a-zA-Z]+ \d+, \d+)/)[1]
        Date.parse(x).to_s
      else
        nil
      end
    end

    emits :bonus_reward_miles do
      if has_bonus_reward_miles
        doc.css('.air-miles')[0].content.match(/(\d+)/)[1].to_f
      else
        0
      end
    end

    emits :bonus_reward_miles_ends_on do
      if has_bonus_reward_miles
        x = doc.css('.air-miles-end-date')[0].content.match(/Until ([a-zA-Z]+ \d+, \d+)/)[1]
        Date.parse(x).to_s
      else
        nil
      end
    end

    # emits :stock_type do
    #   product_details_form('stock type')
    # end

    emits :type do
      [
        primary_category,
        secondary_category,
        varietal,
      ].compact
    end

    emits :primary_category do
      doc.css('#WC_BreadCrumb_Link_1')[0].content.strip
    end

    emits :secondary_category do
      doc.css('#WC_BreadCrumb_Link_2')[0].content.strip
    end

    emits :origin do
      match = product_details_form("Made in:")
      if match
        place = match.
          gsub('Made in: ', '').
          gsub('/Californie', '').
          gsub('Bosnia\'Hercegovina', 'Bosnia and Herzegovina').
          gsub('Is. Of', 'Island of').
          gsub('Italy Quality', 'Italy').
          gsub('Usa-', '').
          gsub(', Rep. Of', '').
          gsub('&', 'and').
          gsub('Region Not Specified, ', '')
        place.split(',').map { |s| s.strip }.uniq.join(', ')
      end
    end

    emits :package do
      result = product_details_form.find do |k,v|
        x = k.match(/(\d+) mL [bottle|gift]/i)
        x ? x : nil
      end

      result ? result[0] : nil
    end

    # emits :package_unit_type do
    #   volume_helper.unit_type
    # end

    emits :volume_in_milliliters do
      #TODO FIX: package is null
      result = package.match(/(\d+) mL [bottle|gift]/i)
      result[1].to_i if result
    end

    # emits :total_package_units do
    #   volume_helper.total_units
    # end

    # emits :total_package_volume_in_milliliters do
    #   volume_helper.package_volume
    # end

    # emits :volume_in_milliliters do
    #   CrawlKit::VolumeHelper[package]
    # end

    emits :alcohol_content do
      product_details_form("Alcohol/Vol").to_f
    end

    # emits :price_per_liter_of_alcohol_in_cents do
    #   if alcohol_content > 0 && volume_in_milliliters > 0
    #     alc_frac = alcohol_content.to_f / 1000.0
    #     alc_vol  = (volume_in_milliliters.to_f / 1000.0) * alc_frac
    #     (price_in_cents.to_f / alc_vol).to_i
    #   else
    #     0
    #   end
    # end

    # emits :price_per_liter_in_cents do
    #   if volume_in_milliliters > 0
    #     (price_in_cents.to_f / (volume_in_milliliters.to_f / 1000.0)).to_i
    #   else
    #     0
    #   end
    # end

    # emits :sugar_content do
    #   if (match = find_info_line(/\ASugar Content : /))
    #     match.gsub('Sugar Content : ', '')
    #   end
    # end

    emits :producer_name do
      product_details_form("By:")
    end

    emits :varietal do
      product_details_form("Varietal:")
    end

    emits :board do
      "LCBO"
    end


    emits :released_on do
      if html.include?('Release Date:')
        x = product_details_form("Release Date:")
        Date.parse(x).to_s
      else
        nil
      end
    end

    # emits :is_discontinued do
    #   html.include?('PRODUCT DISCONTINUED')
    # end

    emits :has_limited_time_offer do
      html.include?('Limited Time Offer')
    end

    emits :has_bonus_reward_miles do
      html.include?('Bonus AIR MILES')
    end

    # emits :has_value_added_promotion do
    #   html.include?('<B>Value Added Promotion</B>')
    # end

    # emits :is_seasonal do
    #   html.include?('<font color="#ff0000">SEASONAL/LIMITED QUANTITIES</font>')
    # end

    emits :is_vqa do
      html.include?("This is a VQA wine")
    end

    emits :is_kosher do
      html.include?('This is a Kosher product.')
    end

    emits :description do
      doc.css('.description blockquote')[0].content rescue nil
    end

    # emits :serving_suggestion do
    #   if html.include?('<B>Serving Suggestion</B>')
    #     match = html.match(/<B>Serving Suggestion<\/B><\/font><BR>\n\t\t\t(.+?)<BR><BR>/m)
    #     CrawlKit::CaptionHelper[match && match.captures[0]]
    #   end
    # end

    # emits :tasting_note do
    #   if html.include?('<B>Tasting Note</B>')
    #     match = html.match(/<B>Tasting Note<\/B><\/font><BR>\n\t\t\t(.+?)<BR>\n\t\t\t<BR>/m)
    #     CrawlKit::CaptionHelper[match && match.captures[0]]
    #   end
    # end

    # emits :value_added_promotion_description do
    #   if has_value_added_promotion
    #     match = html.match(/<B>Value Added Promotion<\/B><\/FONT><BR>(.+?)<BR><BR>/m)
    #     CrawlKit::CaptionHelper[match && match.captures[0]]
    #   end
    # end

    # emits :image_thumb_url do
    #   if (img = doc.css('#image_holder img').first)
    #     normalize_image_url(img[:src])
    #   end
    # end

    emits :label_url do
      "http://www.foodanddrink.ca/assets/products/720x720/#{id.to_s.rjust(7,'0')}.jpg"
    end

    emits :image_url do
      if (img = doc.css('.images img').first)
        path = normalize_image_url(img[:src])

        begin
          request = Typhoeus::Request.new(path)
          response = request.run
          path if response.code == 200
        rescue
          nil
        end
      end
    end

    emits :upc do
      upc_path = "http://stage.lcbo.com/lcbo-webapp/productdetail.do?itemNumber=%s" % id
      begin
        xml = open(upc_path)
        upc = Nokogiri::XML(xml).at('upcNumber').inner_text
      rescue
       nil
      end
    end

    def volume_helper
      @volume_helper ||= CrawlKit::VolumeHelper.new(package)
    end

    def has_package?
      !info_cell_lines[2].include?('Price:')
    end

    def stock_category
      cat = get_info_lines_at_offset(12).reject do |line|
        l = line.strip
        l == '' ||
        l.include?('Price:') ||
        l.include?('Bonus Reward Miles Offer') ||
        l.include?('Value Added Promotion') ||
        l.include?('Limited Time Offer') ||
        l.include?('NOTE:')
      end.first
      cat ? cat.strip : nil
    end

    def product_details_form(name=nil)
      result = doc.css("#item-accordion-aside-product-details")[0].content.strip.gsub(
        /(\t)+/, "\t").gsub(
        /(\r\n|\n)+/, "\n")
      result = result.split(/\n\t\n\t|\n/).map{|e| e.strip}.each_slice(2).to_a

      if name
        result.each do |k,v|
          return v if name == k
        end
        return nil
      else
        result
      end
    end

    def get_info_lines_at_offset(offset)
      raw_info_cell_lines.select do |line|
        match = line.scan(/\A[\s]+/)[0]
        match ? offset == match.size : false
      end
    end

    def info_cell_text
      @info_cell_text ||= info_cell_lines.join("\n")
    end

    def find_info_line(regexp)
      info_cell_lines.select { |l| l =~ regexp }.first
    end

    def raw_info_cell_lines
      @raw_info_cell_lines ||= info_cell_element.content.split(/\n/)
    end

    def info_cell_lines
      @info_cell_lines ||= begin
        raw_info_cell_lines.map { |l| l.strip }.reject { |l| l == '' }
      end
    end

    def info_cell_line_after(item)
      (i = info_cell_lines.index(item)) ? info_cell_lines[i + 1] : nil
    end

    def info_cell_html
      @info_cell_html ||= info_cell_element.inner_html
    end

    def info_cell_element
      doc.css('table[width="478"] td[height="271"] td[colspan="2"].main_font')[0]
    end

    def normalize_image_url(url)
      return unless url
      return if url.include?('default')
      url.include?('http://') ? url : File.join('http://www.lcbo.ca', url)
    end

    # def verify_third_info_cell
    #   return unless has_package? && info_cell_lines[2][0,1] != '|'
    #   raise CrawlKit::MalformedError,
    #     "Expected third line in info cell to begin with bar. LCBO No: " \
    #     "#{id}, Dump: #{info_cell_lines[2].inspect}"
    # end

    # def verify_response_not_blank
    #   return unless html.strip == ''
    #   raise CrawlKit::NotFoundError,
    #     "product #{id} does not appear to exist"
    # end

    # def verify_product_name
    #   return unless product_details_form('itemName').strip == ''
    #   raise CrawlKit::NotFoundError,
    #     "can not locate name for product #{id}"
    # end

    # def verify_product_details_form
    #   return unless doc.css('form[name="productdetails"]').empty?
    #   raise CrawlKit::MalformedError,
    #     "productdetails form not found in doc for product #{id}"
    # end

  end
end
