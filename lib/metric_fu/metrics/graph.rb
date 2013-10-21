MetricFu.lib_require { 'utility' }
MetricFu.lib_require { 'io' }
module MetricFu
  class Graph

    attr_accessor :graph_engine, :output_directory, :graphers

    def initialize(output_directory = MetricFu::Io::FileSystem.directory('output_directory'))
      @graph_engine = MetricFu.configuration.graph_engine
      @output_directory = output_directory
      @graphers = MetricFu::Grapher.enabled_graphers.map do |grapher|
        grapher.new(output_directory: output_directory)
      end
    end

    def generate
      return if self.graphers.empty?
      mf_log "Generating graphs"
      MetricFu::Utility.metric_files.each do |metric_file|
        graph(metric_file)
      end
    end

    def graph(metric_file)
      self.graphers.each do |grapher|
        metric = grapher.metric
        mf_debug "Generating graphs for #{metric_file.filename} and metric #{metric}"
        grapher.get_metrics(metric_file)
        grapher.graph!
      end
    end

  end
end
