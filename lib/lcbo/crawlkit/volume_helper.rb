class VolumeHelper

  def self.calculations
    @@calculations ||= {}
  end

  def initialize(input)
    @input = input
  end

  def self.[](input_string)
    new(input_string).as_milliliters
  end

  def calculations
    self.class.calculations
  end

  def match
    return [] unless @input
    @captures ||= begin
      if (match = @input.match(/\A([0-9]+) mL|\A([0-9]+)x([0-9]+) mL/))
        match.captures.compact
      else
        []
      end
    end
  end

  def as_milliliters
    return 0 unless @input
    calculations[@input] ||= begin
      case match.size
      when 1
        match[0].to_i
      when 2
        match[0].to_i * match[1].to_i
      else
        0
      end
    end
  end

end
