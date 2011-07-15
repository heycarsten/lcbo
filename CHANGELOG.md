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
