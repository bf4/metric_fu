require 'map'
module MetricFu

  def OptionsHash(options_hash)
    case options_hash
    when MetricFu::OptionsHash then OptionsHash
    else                      OptionsHash.new(options_hash)
    end
  end

  class OptionsHash < Map

  end
end
