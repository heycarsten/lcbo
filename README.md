# LCBO Gem

Request and parse store, product, inventory, and product search pages directly from the [LCBO website](http://lcbo.com).

## Installation & Use

Install it using Ruby Gems: `gem install lcbo`

    require 'lcbo'

    LCBO.store(511)
    # => { :store_no => 511, :name => "King & Spadina", ... }

    LCBO.product(18)
    # => { :product_no => 11, :name => "Heineken Lager", ... }

    LCBO.inventory(18)
    # => { :product_no => 18, :inventory_count => 40398, :inventories => [ ... ] }

    LCBO.products_list(1)
    # => { :page => 1, :final_page => 108, ..., :product_nos => [ ... ] }
