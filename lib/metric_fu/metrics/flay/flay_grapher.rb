MetricFu.reporting_require { 'graphs/grapher' }
module MetricFu
  class FlayGrapher < Grapher

    def self.metric
      :flay
    end

    def initialize(*)
      super
    end

    def score_key
      :total_score
    end

    def title
      'Flay: duplication'
    end

  end
end
