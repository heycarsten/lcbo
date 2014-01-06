# LCBO: The Ruby Gem

This library is used to gather data for [LCBO API](http://lcboapi.com). It
allows you to request and parse store, product, inventory, product list, and
store list pages directly from the [LCBO](http://lcbo.com) website.

## Synopsis

```ruby
  require 'lcbo'

  LCBO.store(511)
  # => { :id => 511, :name => "King & Spadina", ... }

  LCBO.product(18)
  # => { :id => 18, :name => "Heineken Lager", ... }

  LCBO.inventory(18)
  # => { :id => 18, :inventory_count => 40398, :inventories => [ ... ] }

  LCBO.product_list(1)
  # => { :page => 1, :final_page => 108, ..., :product_ids => [ ... ] }

  LCBO.store_list
  # => { :store_ids => [1, 2, 3, 4, 5, 6, 8, 9, 10, 11, ...] }
```

## Is It Good?

Yes.

## Is It Production Ready?

Yes. This codebase has been in use for over 4 years powering [LCBO API](http://lcboapi.com).

## Getting It

Package available through [RubyGems](http://rubygems.org/gems/lcbo): `gem install lcbo`

## Compatibility

* Ruby 1.9.3 MRI
* Ruby 2.0.0 MRI

## Notes

 * This is not "LCBO API In A Box", it is the data-gathering component of LCBO API.
 * Don't be evil, be nice!
