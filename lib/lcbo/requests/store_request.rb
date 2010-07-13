class StoreRequest

  include LCBO::CrawlKit::Request

  uri_template 'http://www.lcbo.com/lcbo-ear/jsp/storeinfo.jsp?STORE={store_no}&language=EN'

end
