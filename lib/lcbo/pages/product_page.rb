module LCBO
  class ProductPage

    include CrawlKit::Page

    uri 'https://www.lcbo.com/en/storeinventory/?sku={id}'

    # I CANNOT USE This url b/c it uses JS to update
    # uri 'https://www.lcbo.com/en/catalogsearch/result/#q={id}'

    # uri 'https://www.lcbo.com/lcbo/product/name/{id}'
    # uri 'http://lcbo.com/lcbo-ear/lcbo/product/details.do?language=EN&itemNumber={id}'

    on :after_parse,  :perform_real_request
    # on :after_parse,  :verify_product_details_form
    # on :after_parse,  :verify_product_name
    # on :after_parse,  :verify_third_info_cell

    # emits :xdoc do
    #   doc
    # end

    emits :url do
      doc.css('link[rel=canonical]')[0].attr(:href) rescue nil
    end

    # Original url needs to be parsed for actual product page url and a 2nd request needs to be performed.
    def perform_real_request
      if @real_request_performed
        # puts "ALREADY PERFORMED HIZZY"
      else
        @real_request_performed = true
        real_request_url = doc.css('h1 a[title="Product Name"]')[0].attr(:href)

        @response = Timeout.timeout(LCBO.config[:timeout]) do
          Typhoeus::Request.new(real_request_url, {method:'GET'}).run
        end
        @html     = @response.body
        @doc      = Nokogiri::HTML(@html, nil, 'UTF-8')

        # puts "HIZZAH"
      end
    end

    emits :id do
      query_params[:id].to_i
    end

    emits :code2 do
      doc.css('meta[name="pageId"]')[0].attr(:content) rescue nil
    end

    emits :name do
      # CrawlKit::TitleCaseHelper[doc.css("#ProductInfoName_#{id}")[0].content]
      CrawlKit::TitleCaseHelper[doc.css('title')[0].content.split(' | ').first]
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
      (doc.css('meta[property="product:price:amount"]')[0].attr('content').strip.to_f * 100).round rescue 0
    end

    emits :sale_price_in_cents do
      (doc.css('span[data-price-type="oldPrice"]')[0].attr('data-price-amount').to_f * 100).round rescue 0
    end

    emits :regular_price_in_cents do
      if has_limited_time_offer
        sale_price_in_cents
      else
        price_in_cents
      end
    end

    emits :limited_time_offer_savings_in_cents do
      regular_price_in_cents - price_in_cents
    end

    emits :limited_time_offer_ends_on do
      if has_limited_time_offer
        x = doc.css('.product-info-price .limited-text')[0].content
        puts x.inspect
        y = x.match(/Sale Ends\: (.*)/)[1]
        Date.parse(y).to_s
      else
        nil
      end
    end

    emits :bonus_reward_miles do
      if has_bonus_reward_miles
        doc.css('.airmiles-section span')[0].content.match(/(\d+)/)[1].to_f
      else
        0
      end
    end

    emits :bonus_reward_miles_ends_on do
      if has_bonus_reward_miles
        x = doc.css('.airmiles-section')[0].content.match(/Until.([a-zA-Z]+ \d+ ?, ?\d+)/)[1]
        Date.parse(x).to_s
      else
        nil
      end
    end

    # emits :stock_type do
    #   product_details_form('stock type')
    # end

    # REDO
    # emits :type do
    #   [
    #     primary_category,
    #     secondary_category,
    #     varietal,
    #   ].compact
    # end

    # REDO
    # emits :primary_category do
    #   doc.css('#WC_BreadCrumb_Link_1')[0].content.strip
    # end

    # REDO
    # emits :secondary_category do
    #   doc.css('#WC_BreadCrumb_Link_2')[0].content.strip
    # end


    emits :origin do
      origin_match = product_details_form("Made In")
      if origin_match
        place = origin_match.
          gsub('Made in: ', '').
          gsub('/Californie', '').
          gsub('Bosnia\'Hercegovina', 'Bosnia and Herzegovina').
          gsub('Is. Of', 'Island of').
          gsub('Italy Quality', 'Italy').
          gsub('Usa-', '').
          gsub(', Rep. Of', '').
          gsub('&', 'and').
          gsub('Region Not Specified, ', '')
        place.split(',').map{ |s| s.strip }.uniq.join(', ')
      end
    end

    # emits :package do
    #   result = product_details_form.find do |k,v|
    #     x = k.match(/(\d+) mL [bottle|gift]/i)
    #     x ? x : nil
    #   end rescue nil

    #   result ? result[0] : nil
    # end

    # emits :package_unit_type do
    #   volume_helper.unit_type
    # end

    # REDO
    # emits :volume_in_milliliters do
    #   #TODO FIX: package is null
    #   result = package.match(/(\d+) mL [bottle|gift]/i)
    #   result[1].to_i if result
    # end

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
      product_details_form("By")
    end

    emits :varietal do
      product_details_form("Varietal")
      # staging_lcbo_data.at('wineVarietal').inner_text rescue nil
    end

    emits :board do
      "LCBO"
    end


    emits :released_on do
      product_details_form("Release Date")
    end

    # emits :is_discontinued do
    #   html.include?('PRODUCT DISCONTINUED')
    # end

    emits :has_limited_time_offer do
      sale_price_in_cents != 0
      # html.include?('Limited Time Offer')
    end

    emits :has_bonus_reward_miles do
      html.include?('Bonus AIR MILES') && !doc.css('.share-links .airmiles-section').empty?
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
      doc.css('.testing_note')[0].content rescue nil
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
      normalize_image_url("http://www.foodanddrink.ca/assets/products/720x720/#{id.to_s.rjust(7,'0')}.jpg")
    end

    emits :image_url do
      normalize_image_url("http://www.foodanddrink.ca/assets/products/720x720/#{id.to_s.rjust(7,'0')}.jpg")
      # if (img = doc.css('img#productMainImage').first)
      #   normalize_image_url(img[:src])
      # end
    end

    emits :upc do
      # staging_lcbo_data.at('upcNumber').inner_text rescue nil
    end

    emits :online_inventory do
      0
      # doc.css('.home-shipping-available')[0].content.strip.match(/(\d*) available/)[1] rescue 0
    end

    # NO LONGER AVAILABLE
    # def staging_lcbo_data
    #   @staging_lcbo_data =
    #   begin
    #     upc_path = "http://stage.lcbo.com/lcbo-webapp/productdetail.do?itemNumber=%s" % id
    #     xml = open(upc_path)
    #     Nokogiri::XML(xml)
    #   rescue
    #     nil
    #   end
    # end

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
      if name && @product_details_hash
        @product_details_hash[name]
      elsif name
        @product_details_hash = {}
      
        doc.css("#moredetail li").each do |x|
          @product_details_hash[x.css('div')[0].content.strip] = x.css('div')[1].content.strip
        end

        product_details_form(name)
      else
        @product_details_hash
      end
    rescue
      raise "Unable to parse product-details-list"
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
      url = url.include?('http://') ? url : File.join('http://www.lcbo.com', url)

      response = Typhoeus.get(url, followlocation:true)
      url = response.effective_url

      return unless [200].include? response.code
      return if url.include?('default')
      return if url.include?('generic')

      url
    rescue
      nil
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
