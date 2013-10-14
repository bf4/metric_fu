module MetricFu
  class GraphEngine

    attr_accessor :graph_engines, :graph_engine
    def initialize
      @graph_engines = [:bluff, :gchart]
      graph_engines.each do |engine_name|
        require_graph_engine(engine_name)
      end
      @graph_engine = :bluff
    end

    def add_graph_engine(graph_engine)
      require_graph_engine(graph_engine)
      self.graph_engines = (graph_engines << graph_engine).uniq
    end

    def configure_graph_engine(graph_engine)
      require_graph_engine(graph_engine)
      self.graph_engine = graph_engine
    end

    private

    def require_graph_engine(engine_name)
      require "metric_fu/reporting/graphs/engines/#{engine_name}"
    end

  end
end
