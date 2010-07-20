module LCBO
  class ProductPage

    include CrawlKit::Page

    uri 'http://lcbo.com/lcbo-ear/lcbo/product/details.do?' \
        'language=EN&itemNumber={product_no}'

    on :before_parse, :verify_response_not_blank
    on :before_parse, :verify_not_discontinued
    on :after_parse,  :verify_product_details_form
    on :after_parse,  :verify_product_name
    on :after_parse,  :verify_second_info_cell

    emits :product_no do
      query_params[:product_no].to_i
    end

    emits :name do
      CrawlKit::TitleCaseHelper[product_details_form('itemName')]
    end

    emits :price_in_cents do
      (product_details_form('price').to_f * 100).to_i
    end

    emits :stock_type do
      product_details_form('stock type')
    end

    emits :primary_category do
      return unless stock_category
      cat = stock_category.split(',')[0]
      cat ? cat.strip : cat
    end

    emits :secondary_category do
      return unless stock_category
      cat = stock_category.split(',')[1]
      cat ? cat.strip : cat
    end

    emits :origin do
      match = find_info_line(/\AMade in: /)
      return unless match
      place = match.
        gsub('Made in: ', '').
        gsub('/Californie', '').
        gsub('Bosnia\'Hercegovina', 'Bosnia and Herzegovina').
        gsub('Is. Of', 'Island of').
        gsub('Italy Quality', 'Italy').
        gsub('Usa-', '').
        gsub(', Rep. Of', '').
        gsub('&', 'and')
      place.split(',').map { |s| s.strip }.uniq.join(', ')
    end

    emits :package do
      @package ||= begin
        string = info_cell_lines[2]
        string.include?('Price: ') ? nil : string
      end
    end

    emits :volume_in_milliliters do
      CrawlKit::VolumeHelper[package]
    end

    emits :alcohol_content do
      match = find_info_line(/ Alcohol\/Vol.\Z/)
      return unless match
      ac = match.gsub(/%| Alcohol\/Vol./, '').to_f
      ac.zero? ? nil : (ac * 100).to_i
    end

    emits :sugar_content do
      match = match = find_info_line(/\ASugar Content : /)
      return unless match
      match.gsub('Sugar Content : ', '')
    end

    emits :producer_name do
      match = find_info_line(/\ABy: /)
      return unless match
      match.gsub(/By: |Tasting Note|Serving Suggestion|NOTE:/, '')
    end

    private

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
      info_cell_lines.join("\n")
    end

    def find_info_line(regexp)
      info_cell_lines.select { |l| l =~ regexp }.first
    end

    def raw_info_cell_lines
      info_cell_element.content.split(/\n/)
    end

    def info_cell_lines
      raw_info_cell_lines.map { |l| l.strip }.reject { |l| l == '' }
    end

    def info_cell_element
      doc.css('table[width="478"] td[height="271"] td[colspan="2"].main_font')[0]
    end

    def verify_second_info_cell
      return unless info_cell_lines[1][-1, 1] != '|'
      raise MalformedDocumentError,
        'Expected second line in info cell to end with bar for product ' \
        "#{product_no}: #{info_cell_lines[1][-1, 1]}"
    end

    def verify_response_not_blank
      return unless html.strip == ''
      raise MissingResourceError, "product #{product_no} does not appear to exist"
    end

    def verify_product_name
      return unless product_details_form('itemName').strip == ''
      raise MissingResourceError, "can not locate name for product #{product_no}"
    end

    def verify_product_details_form
      return unless doc.css('form[name="productdetails"]').empty?
      raise MalformedDocumentError,
        "productdetails form not found in doc for product #{product_no}"
    end

    def verify_not_discontinued
      return unless html.include?('PRODUCT DISCONTINUED')
      raise MissingResourceError, "product #{product_no} has been discontinued"
    end

  end
end
