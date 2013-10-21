MetricFu.lib_require { 'options_hash' }
require 'multi_json'
module MetricFu
  class Grapher
  include MetricFu::Io

    def self.metric
      raise "#{__LINE__} in #{__FILE__} from #{caller[0]}"
    end

    def metric
      self.class.metric
    end

    @graphers = []
    # @return all subclassed graphers [Array<MetricFu::Grapher>]
    def self.graphers
      @graphers
    end

    def self.enabled_graphers
      MetricFu::Metric.enabled_graphed_metrics.map do |metric|
        get_grapher(metric.name)
      end
    end

    def self.inherited(subclass)
      @graphers << subclass
    end

    def self.get_grapher(metric)
      graphers.find{|grapher|grapher.metric.to_s == metric.to_s}
    end

    def self.graph_defaults
      graph_size = "1000x600"
      graph_defaults = <<-EOS
        var g = new Bluff.Line('graph', "#{graph_size}");
        g.theme_37signals();
        g.tooltips = true;
        g.title_font_size = "24px"
        g.legend_font_size = "12px"
        g.marker_font_size = "10px"
      EOS
      graph_defaults
    end

    attr_reader :output_directory, :scores, :labels

    def initialize(opts = OptionsHash.new)
      opts = MetricFu::OptionsHash.new(opts)
      @scores = []
      @labels = OptionsHash.new
      @output_directory = opts[:output_directory] || MetricFu::Io::FileSystem.directory('output_directory')
    end

    def get_metrics(metric_file)
      score = metric_file.score(metric, score_key)
      return unless score

      scores << score.to_i
      labels.update( { labels.size => metric_file.sortable_prefix } )
    end

    def graph
      labels = MultiJson.dump(labels)

      graph_data = Array(data).map do |label, datum|
        "g.data('#{label}', [#{datum}]);"
      end.join("\n")

      content = <<-EOS
        #{self.class.graph_defaults}
        g.title = '#{title}';
        #{graph_data}
        g.labels = #{labels};
        g.draw();
      EOS
      content
    end

    def graph!
      file_for(output_path) {|f| f << graph }
    end

    def output_path
      destination = File.join(self.output_directory, output_filename)
    end

    def score_key
      not_implemented
    end

    def title
      not_implemented
    end

    def data
      [
        ["#{metric}", scores.join(',')]
      ]
    end

    def output_filename
      "#{metric}.js"
    end

    private

    def not_implemented
      raise "#{__LINE__} in #{__FILE__} from #{caller[0]}"
    end

  end
end
