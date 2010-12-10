# LCBO: The Ruby Gem

This library is used to gather data for [LCBO API](http://lcboapi.com). It
allows you to request and parse store, product, inventory, product list, and
store list pages directly from the [LCBO](http://lcbo.com) website.

## Synopsis

    require 'lcbo'

    LCBO.store(511)
    # => { :store_no => 511, :name => "King & Spadina", ... }

    LCBO.product(18)
    # => { :product_no => 18, :name => "Heineken Lager", ... }

    LCBO.inventory(18)
    # => { :product_no => 18, :inventory_count => 40398, :inventories => [ ... ] }

    LCBO.products_list(1)
    # => { :page => 1, :final_page => 108, ..., :product_nos => [ ... ] }

    LCBO.store_list
    # => { :store_nos => [1, 2, 3, 4, 5, 6, 8, 9, 10, 11, ...] }

## Crawlers

Some examples of crawlers exist
[here](http://github.com/heycarsten/lcbo/blob/master/examples). You can also
check out the
[crawler spec](http://github.com/heycarsten/lcbo/blob/master/spec/crawlkit/crawler_spec.rb)
to see how to interact with them.

## Installation

Use RubyGems: `gem install lcbo`

## Notes

 * Works with Ruby 1.9.2, not tested with 1.8.X or 1.9.1.
 * Don't be evil, be nice.
 * Lots of room to improve &mdash; fork your face off!

## Links

 * [Issue tracker](http://github.com/heycarsten/lcbo/issues)
 * [Source code](http://github.com/heycarsten/lcbo)
 * [License](http://github.com/heycarsten/lcbo/blob/master/LICENSE)
