# Class opened and modified by requiring a graph engine
module MetricFu
  class Grapher
    attr_accessor :output_directory
    @grapher_module = Module.new
    class << self
      attr_reader :grapher_module
    end

    def initialize(opts = {})
      add_grapher_engine
      self.output_directory = opts[:output_directory]
    end

    def output_directory
      @output_directory || MetricFu::Io::FileSystem.directory('output_directory')
    end

    def add_grapher_engine
      self.class.require_graphing_gem
      mf_log "Extending #{self.class.inspect} with #{self.class.grapher_module.inspect}"
      extend self.class.grapher_module
    end

    def self.require_graphing_gem
      graph_engine = MetricFu.configuration.graph_engine
      grapher_name = graph_engine.to_s.capitalize + "Grapher"
      @grapher_module = MetricFu.const_get(grapher_name)
      require grapher_module.gem_name
    rescue LoadError
      mf_log "#"*99 + "\n" +
           "If you want to use google charts for graphing, you'll need to install the googlecharts rubygem." +
           "\n" + "#"*99
    end

  end
end
