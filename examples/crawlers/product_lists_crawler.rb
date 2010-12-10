class ProductListsCrawler

  include CrawlKit::Crawler

  def request(params)
    LCBO.product_list(params[:next_page] || 1)
  end

  def continue?(current_params)
    current_params[:next_page] ? true : false
  end

  def reduce
    requests.map { |params| params[:product_nos] }.flatten
  end

end
