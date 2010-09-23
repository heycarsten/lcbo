# LCBO: The Ruby Gem

This library is used to gather data for [LCBO API](http://lcboapi.com). It allows you to request and parse store, product, inventory, and product list pages directly from the [LCBO](http://lcbo.com) website.

## Synopsis

    require 'lcbo'

    LCBO.store(511)
    # => { :store_no => 511, :name => "King & Spadina", ... }

    LCBO.product(18)
    # => { :product_no => 11, :name => "Heineken Lager", ... }

    LCBO.inventory(18)
    # => { :product_no => 18, :inventory_count => 40398, :inventories => [ ... ] }

    LCBO.products_list(1)
    # => { :page => 1, :final_page => 108, ..., :product_nos => [ ... ] }

## Installation

Use Ruby Gems: `gem install lcbo`

## Notes

 * Works with Ruby 1.9.2, not tested with 1.8.X or 1.9.1.
 * Don't be evil, be nice.
 * Lots of room to improve &mdash; fork your face off!

## Links

 * [Issue tracker](http://github.com/heycarsten/lcbo/issues)
 * [Source code](http://github.com/heycarsten/lcbo)
 * [License](http://github.com/heycarsten/lcbo/blob/master/LICENSE)
