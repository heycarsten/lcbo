module LCBO
  module HashExt

    def self.symbolize_keys(input)
      Hash[input.map { |key, value| [key.to_sym, value] }]
    end

  end
end
