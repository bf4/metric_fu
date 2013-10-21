MetricFu.lib_require { 'utility' }
MetricFu.lib_require { 'options_hash' }
module MetricFu

  def MetricFile(metric_file)
    case metric_file
    when MetricFu::MetricFile then metric_file
    else                      MetricFile.new(metric_file)
    end
  end

  class MetricFile

    def self.from_file_pattern(file_pattern)
      Dir[file_pattern].sort.map do |filename|
        new(filename)
      end
    end

    attr_reader :filename, :date_parts

    def initialize(filename)
      @filename = filename
      @date_parts = year_month_day_from_filename(filename)
    end

    def data
      @data ||= OptionsHash.new(MetricFu::Utility.load_yaml_file(filename))
    end

    def score(metric, score_key)
      data.fetch(metric, {})[score_key]
    end

    def sortable_prefix
      @sortable_prefix ||= "#{date_parts[:m]}/#{date_parts[:d]}"
    end

    private

    def year_month_day_from_filename(path_to_file_with_date)
      date = path_to_file_with_date.match(/\/(\d+).yml$/)[1]
      {:y => date[0..3].to_i, :m => date[4..5].to_i, :d => date[6..7].to_i}
    end

  end
end
