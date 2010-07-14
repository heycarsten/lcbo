module LCBO
  class InventoriesCrawler

    def self.run(product_nos, &block)
      raise ArgumentError, 'block expected' unless block_given?
      product_nos.each do |product_no|
        begin
          yield InventoryRequest.parse(:product_no => product_no).as_hash
        rescue
        end
      end
    end

  end
end
