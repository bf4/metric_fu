module MetricFu
  class MetricRailsBestPractices < Metric

    def name
      :rails_best_practices
    end

    def default_run_options
      {}
    end

    def has_graph?
      true
    end

    def enable
      if MetricFu.configuration.supports_ripper?
        super
      else
        mf_debug("Rails Best Practices is only available in MRI 1.9. It requires ripper")
      end
    end

    def activate
      activate_library('rails_best_practices')
      activate_library('metric_fu/sexp_ext')
      super
    end

  end
end
