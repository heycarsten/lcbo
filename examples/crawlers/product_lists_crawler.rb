class ProductListsCrawler

  include LCBO::CrawlKit::Crawler

  def request(params)
    LCBO.product_list(params[:next_page] || 1)
  end

  def continue?(current_params)
    current_params[:next_page] ? true : false
  end

  def reduce
    responses.map { |params| params[:product_ids] }.flatten
  end

end
