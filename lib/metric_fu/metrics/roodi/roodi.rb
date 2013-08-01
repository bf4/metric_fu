module MetricFu
  class Roodi < Generator

    def emit
      files_to_analyze = MetricFu.roodi[:dirs_to_roodi].map{|dir| Dir[File.join(dir, "**/*.rb")] }
      files = remove_excluded_files(files_to_analyze.flatten)
      config = MetricFu.roodi[:roodi_config] ? "-config=#{MetricFu.roodi[:roodi_config]}" : ""
      options_string = %Q(#{config} #{files.join(" ")})
      command = %Q(mf-roodi #{options_string})
      mf_debug "** #{command}"
      original_argv = ARGV.dup
      require 'shellwords'
      ARGV.clear; ARGV.concat Shellwords.shellwords(options_string)

      require 'rubygems'
      require 'metric_fu_requires'
      version = MetricFu::MetricVersion.roodi
      gem 'metric_fu-roodi', version
      gem_name = 'metric_fu-roodi'
      library_name = 'metric_fu-roodi'
      @output = MfDebugger::Logger.capture_output { load Gem.bin_path(gem_name, library_name, version) }
      # @output = `#{command}`
    end

    def analyze
      @matches = @output.chomp.split("\n").map{|m| m.split(" - ") }
      total = @matches.pop
      @matches.reject! {|array| array.empty? }
      @matches.map! do |match|
        file, line = match[0].split(':')
        problem = match[1]
        {:file => file, :line => line, :problem => problem}
      end
      @roodi_results = {:total => total, :problems => @matches}
    end

    def to_h
      {:roodi => @roodi_results}
    end

    def per_file_info(out)
      @matches.each do |match|
        out[match[:file]] ||= {}
        out[match[:file]][match[:line]] ||= []
        out[match[:file]][match[:line]] << {:type => :roodi, :description => match[:problem]}
      end
    end
  end
end
