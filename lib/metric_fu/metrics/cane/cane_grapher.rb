MetricFu.reporting_require { 'graphs/grapher' }
module MetricFu
  class CaneGrapher < Grapher

    def self.metric
      :cane
    end

    def score_key
      :total_violations
    end

    def title
      'Cane: code quality threshold violations'
    end

  end
end

