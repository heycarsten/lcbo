Version 1.5.0

  * Updated Gemfile to use an explicit source URL.
  * Updated dependencies to ensure compatability with Ruby 2.0.0.
  * Updated default user-agent string to be more informative.

Version 1.4.0

  * Fixed issue with store list spec not using stubbed HTML data.
  * Updated `ProductListPage` to use new style GET-based request instead of the
    previously used POST-based request endpoint.

Version 1.3.0

  * Updated `StoreListPage` to use current XML-based store locator endpoint.
  * Fixed issue where store opening times of 12:00 PM were reported as midnight.
  * Fixed product description, serving suggestion, and tasting note parsing.
  * Added new `#sugar_in_grams_per_liter` attribute to `ProductPage`,
    `#sugar_content` still reflects the product sweetness descriptor if present.
  * Added new `#varietal` attribute to `ProductPage`, this appears for some
    wines selected by the LCBO.
  * Added new `#style` attribute to `ProductPage`, this reflects the LCBO's
    designated style for selected wines.
  * Fixed alcohol content parsing for products.
  * Added `#clearance_sale_savings_in_cents` and `#has_clearance_sale` indicator
    to `ProductPage` and included savings calculation in product price.
  * Fixed product category parsing and added new `#tertiary_category`.
  * Updated dependencies.

Version 1.2.3

  * Updated `ProductPage` to return `RedirectedError` for gift cards which now
    redirect to a special page.

Version 1.2.2

  * Updated `ProductListPage` to deal with changes made on LCBO.com which were
    causing it to fail.

Version 1.2.1

  * Updated `StorePage` to deal with changes made on LCBO.com.

Version 1.2.0

  * Updated dependencies.
  * Fixed latitude/longitude parsing for stores.

Version 1.1.1

  * Added case to ignore default thumbnail images for Vintages.

Version 1.1.0

 * Added image URLs to products when available.
 * Added "IPA" to the list of initialisms.

Version 1.0.2

 * Specified Typhoeus 0.2.4 in gemspec and fixed issue where post body was not
   being sent with requests.

Version 1.0.1

 * Fixed issue where `TagHelper` was not including words with apostrophes (')
   or dashes (-).

Version 1.0.0

 * Fixed issue that affected about 10 products in where if the name began
   with a `(` character the output name would be blank.

Version 1.0.0beta1

 * Added rule to titlecase helper to account for names like L'Andéol.
 * Changed instances of `store_no`, and `product_no`, to `store_id`,
   `product_id`, and `id` where appropriate.

Version 0.11.0

 * Added helper to format phone numbers to (XXX) XXX-XXXX regardless of the
   input format.
 * Added `ProductPage#has_value_added_promotion` and
   `ProductPage#value_added_promotion_description`.
 * Fixed bug where `TagHelper` would return no tags if one of the input values
   was nil.

Version 0.10.1

 * Added `#tags` attribute to `ProductPage` and `StorePage` to provide simple
   stems for full-text search.

Version 0.10.0

 * Moved `CrawlKit` related errors into the `CrawlKit` namespace.
 * Added `:timeout` and `:max_retries` to configuration options and enabled
   auto _n_-retries for timed-out requests.
 * Added `LCBO::CrawlKit::Crawler` mixin as a helper for making crawlers.
 * Added example crawlers for inventories, products, stores, and product list
   pages.

Version 0.9.9

 * Added `ProductPage#is_kosher` to designate Kosher products.
 * Added `StoreListPage` to allow all store IDs to be retrieved in one request.
 * Removed all crawler related code.

Version 0.9.8

 * Now returning Date objects instead of strings for all date attributes.

Version 0.9.7

 * Refactored `TitleCaseHelper` to use the UnicodeUtils library.

Version 0.9.6

 * Removed instances of `Enumerable#reduce` in favour of `Hash[]` for
   constructing hashes.
 * Added `price_per_liter_in_cents` and `price_per_liter_of_alcohol_in_cents`
   to ProductPage.

Version 0.9.5

 * Fixed an encoding bug.

Version 0.9.4

 * Set default value for `ProductListsCrawler`'s `:page` param to zero.

Version 0.9.3

 * 4x speed boost to `InventoryPage.parse` courtesy of Justin Giancola.

Version 0.9.2

 * Fixed potential bug in some versions of Ruby where Object#send semantics
   cause a failure when calling private or protected methods.

Version 0.9.1

 * Removed dependency on Addressable.
 * Refactored tests to use MiniTest::Spec instead of RSpec, removing another
   dependency.

Version 0.9.0

 * Initial public release
