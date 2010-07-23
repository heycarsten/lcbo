# LCBO

A utility library for collecting and normalizing data from the official LCBO website.

## Pages

Pages represent HTML pages available on the LCBO website.

### LCBO::StorePage

Allows you to collect all information for a store.

<pre><code class="ruby">
LCBO.store(511)
</code></pre>

### LCBO::ProductPage

Returns information for a specific product by ID. You can use
`LCBO::ProductsListPage` to crawl for available product numbers.

<pre><code class="ruby">
LCBO.product(18)
</code></pre>

### LCBO::InventoryPage

Returns inventory information for a product at all stores which it is available.

<pre><code class="ruby">
LCBO.inventory(18)
</code></pre>

### LCBO::ProductsListPage

Returns product search index results by page number.

<pre><code class="ruby">
LCBO.products_list(1)
</code></pre>

## Crawlers

Crawlers are simple helpers that emit pages.
