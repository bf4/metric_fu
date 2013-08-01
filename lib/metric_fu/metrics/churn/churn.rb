module MetricFu

  class Churn < Generator

    def emit
      @output = generate_churn_metrics
    end

    def analyze
      if @output.nil? || @output.match(/Churning requires.*git/)
        @churn = {:churn => {}}
      else
        @churn = YAML::load(@output)
      end
    end

    # ensure hash only has the :churn key
    def to_h
      {:churn => @churn[:churn]}
    end

    private

    def generate_churn_metrics
      ensure_output_is_valid_yaml(churn_code)
    end

    def ensure_output_is_valid_yaml(output)
      yaml_start = output.index("---")
      if yaml_start
        output[yaml_start...output.length]
      else
        nil
      end
    end

    def churn_code
      options_string = build_churn_options
      command = "mf-churn #{options_string}"
      mf_debug "** #{command}"
      original_argv = ARGV.dup
      require 'shellwords'
      ARGV.clear; ARGV.concat Shellwords.shellwords(options_string)
require 'metric_fu_requires'

version = MetricFu::MetricVersion.churn
gem 'churn', version
MfDebugger::Logger.capture_output { load Gem.bin_path('churn', 'churn', version) }
      # `#{command}`
    end

    def build_churn_options
      opts = ["--yaml"]
      churn_options.each do |churn_option, command_flag|
        if has_option?(churn_option)
          opts << "#{command_flag}=#{options[churn_option]}"
        end
      end
      opts.join(" ")
    end

    def has_option?(churn_option)
      options.include?(churn_option)
    end
    def churn_options
      {
        :minimum_churn_count => '--minimum_churn_count',
        :start_date => '--start_date'
      }
    end

  end

end
