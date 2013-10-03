# encoding: UTF-8
module SAQ
  class ProductPage

    include CrawlKit::Page

    uri 'http://www.saq.com/page/en/saqcom/type/name/{id}'

    # on :before_parse, :verify_response_not_blank
    # on :after_parse,  :verify_product_details_form
    # on :after_parse,  :verify_product_name
    # on :after_parse,  :verify_third_info_cell

    emits :id do
      query_params[:id].to_i
    end

    emits :name do
      CrawlKit::TitleCaseHelper[doc.css('.product-description-title')[0].content.split("|")[0].strip] rescue 0
    end

    # emits :tags do
    #   CrawlKit::TagHelper[
    #     name,
    #     primary_category,
    #     secondary_category,
    #     origin,
    #     producer_name,
    #     package_unit_type
    #   ]
    # end

    emits :price_in_cents do
      data = doc.css('p.price')[0].content.gsub("$",'').gsub(/Regular\sprice\:\s+/,'').gsub(",",'.').strip.to_f * 100 rescue 0
      data.round
    end

    # emits :regular_price_in_cents do
    #   if has_limited_time_offer
    #     info_cell_line_after('Was:').sub('$ ', '').to_f * 100
    #   else
    #     price_in_cents
    #   end
    # end

    # emits :limited_time_offer_savings_in_cents do
    #   regular_price_in_cents - price_in_cents
    # end

    # emits :limited_time_offer_ends_on do
    #   if has_limited_time_offer
    #     CrawlKit::FastDateHelper[info_cell_line_after('Until')]
    #   else
    #     nil
    #   end
    # end

    # emits :bonus_reward_miles do
    #   if has_bonus_reward_miles
    #     info_cell_line_after('Earn').to_i
    #   else
    #     0
    #   end
    # end

    # emits :bonus_reward_miles_ends_on do
    #   if has_bonus_reward_miles
    #     CrawlKit::FastDateHelper[info_cell_line_after('Until')]
    #   else
    #     nil
    #   end
    # end

    # emits :stock_type do
    #   product_details_form('stock type')
    # end

    emits :board do
      "SAQ"
    end

    # emits :primary_category do
    #   if stock_category
    #     cat = stock_category.split(',')[0]
    #     cat ? cat.strip : cat
    #   end
    # end

    # emits :secondary_category do
    #   if stock_category
    #     cat = stock_category.split(',')[1]
    #     cat ? cat.strip : cat
    #   end
    # end

    # NOT to happy about this !!
    emits :type do
      doc.css('.product-description-title-type')[0].content.split(",")[0].split(" ") rescue []
    end

    emits :country do
      doc.css('.product-description-table-tdL .product-page-subtitle')[0].content.strip rescue nil
    end

    emits :region do
      doc.css('.product-description-region.product-page-subtitle')[0].content.strip rescue nil
    end

    emits :varietal do
      varietal = nil
      details = doc.css("#details li .left")
      details.size.times do |i|
        if details[i].content.strip == "Grape variety(ies)"
          varietal = doc.css("#details li .right")[i].content.strip
          if varietal =~ /100.*\%/
            varietal = varietal.gsub(/100.*\%/,'').strip
          else
            varietal = "Blend"
          end
        end
      end
      varietal
    end

    # emits :package do
    #   @package ||= begin
    #     string = info_cell_lines[2]
    #     string.include?('Price: ') ? nil : string.sub('|','').strip
    #   end
    # end

    # emits :package_unit_type do
    #   volume_helper.unit_type
    # end

    # emits :package_unit_volume_in_milliliters do
    #   volume_helper.unit_volume
    # end

    # emits :total_package_units do
    #   volume_helper.total_units
    # end

    # emits :total_package_volume_in_milliliters do
    #   volume_helper.package_volume
    # end

    emits :sku do
      doc.css('input[name=productId]')[0].attr('value').to_i rescue nil
    end

    emits :upc do
      doc.css('.product-description-row2')[0].content.split("\n")[7].strip rescue nil
    end

    emits :total_units do
      # data = doc.css('.availability-available')[0].content.match(/\d+/)[0].to_i
    end

    emits :volume_in_milliliters do
      data = doc.css('.product-description-title-type')[0].content.split(",")[1].strip rescue []
      if data[-2..-1] == "ml"
        data[0..-4].to_i
      elsif data[-1..-1] == "L"
        (data[0..-3].to_f * 1000).to_i
      else
        0
      end
    end

    emits :alcohol_content do
      doc.css('.product-detailsR span')[1].content.gsub(",",'.')[0..-3].to_f rescue nil
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

    # emits :producer_name do
    #   if (match = find_info_line(/\ABy: /))
    #     CrawlKit::TitleCaseHelper[
    #       match.gsub(/By: |Tasting Note|Serving Suggestion|NOTE:/, '')
    #     ]
    #   end
    # end

    # emits :released_on do
    #   if html.include?('Release Date:')
    #     date = info_cell_line_after('Release Date:')
    #     date == 'N/A' ? nil : CrawlKit::FastDateHelper[date]
    #   else
    #     nil
    #   end
    # end

    # emits :is_discontinued do
    #   html.include?('PRODUCT DISCONTINUED')
    # end

    # emits :has_limited_time_offer do
    #   html.include?('<B>Limited Time Offer</B>')
    # end

    # emits :has_bonus_reward_miles do
    #   html.include?('<B>Bonus Reward Miles Offer</B>')
    # end

    # emits :has_value_added_promotion do
    #   html.include?('<B>Value Added Promotion</B>')
    # end

    # emits :is_seasonal do
    #   html.include?('<font color="#ff0000">SEASONAL/LIMITED QUANTITIES</font>')
    # end

    # emits :is_vqa do
    #   html.include?('This is a <B>VQA</B> wine')
    # end

    # emits :is_kosher do
    #   begin
    #     data = doc.css('.product-detail-item.Kosher')[0].content
    #     if data
    #       data.strip != "No"
    #     else
    #       false
    #     end
    #   rescue
    #     false
    #   end
    # end

    # emits :is_organic do
    #   begin
    #     data = doc.css('.product-detail-item.Organic')[0].content
    #     if data
    #       data.strip != "No"
    #     else
    #       false
    #     end
    #   rescue
    #     false
    #   end
    # end

    emits :description do
      doc.css('#tasting .description')[0].children[5].content.strip rescue nil
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

    # b/c of the open call this is NOT tested
    emits :image_url do
      begin
        possible_image_url = "http://s7d9.scene7.com/is/image/SAQ/#{id}-1?scl=1"
        has_image = open("#{possible_image_url}&req=exists,javascript").read.match(/catalogRecord\.exists \= '(\d)'/)[1].to_i
        normalize_image_url(possible_image_url)
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

    def product_details_form(name)
      doc.css("form[name=\"productdetails\"] input[name=\"#{name}\"]")[0].
        attributes['value'].to_s
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
      return if url.include?('placeholders')
      url.include?('http://') ? url : File.join('http://http://www.bcliquorstores.com', url)
    end

    def verify_third_info_cell
      return unless has_package? && info_cell_lines[2][0,1] != '|'
      raise CrawlKit::MalformedError,
        "Expected third line in info cell to begin with bar. LCBO No: " \
        "#{id}, Dump: #{info_cell_lines[2].inspect}"
    end

    def verify_response_not_blank
      return unless html.strip == ''
      raise CrawlKit::NotFoundError,
        "product #{id} does not appear to exist"
    end

    def verify_product_name
      return unless product_details_form('itemName').strip == ''
      raise CrawlKit::NotFoundError,
        "can not locate name for product #{id}"
    end

    def verify_product_details_form
      return unless doc.css('form[name="productdetails"]').empty?
      raise CrawlKit::MalformedError,
        "productdetails form not found in doc for product #{id}"
    end

  end
end
