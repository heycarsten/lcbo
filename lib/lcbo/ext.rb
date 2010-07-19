module LCBO
  module HashExt

    def self.symbolize_keys(input)
      input.reduce({}) { |hsh, (key, value)| hsh.merge(key.to_sym => value) }
    end

    def self.stringify_keys(input)
      input.reduce({}) { |hsh, (key, value)| hsh.merge(key.to_s => value) }
    end

  end
end
