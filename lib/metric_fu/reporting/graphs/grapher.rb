# Class opened and modified by requiring a graph engine
module MetricFu
  class Grapher

    @grapher_module = Module.new
    class << self
      attr_reader :grapher_module
    end

    attr_accessor :output_directory

    def initialize(opts = {})
      add_grapher_engine
      self.output_directory = opts[:output_directory]
    end

    def output_directory
      @output_directory || MetricFu::Io::FileSystem.directory('output_directory')
    end

    def get_metrics(metrics, sortable_prefix)
      raise "#{__LINE__} in #{__FILE__} from #{caller.join('\n')}"
    end

    def add_grapher_engine
      self.class.require_graphing_gem
      mf_log "Extending #{self.class.inspect} with #{self.class.grapher_module.inspect}"
    end

    def self.graph_engine
      MetricFu.configuration.graph_engine
    end

    def self.require_graphing_gem
      grapher_name = graph_engine.to_s.capitalize + "Grapher"
      @grapher_module = MetricFu.const_get(grapher_name)
      require grapher_module.gem_name
      include grapher_module
    rescue LoadError
      mf_log "#"*99 + "\n" +
           "If you want to use google charts for graphing, you'll need to install the googlecharts rubygem." +
           "\n" + "#"*99
    end

  end
end
