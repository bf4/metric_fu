module MetricFu
  class Loader
    # TODO: This class mostly serves to clean up the base MetricFu module,
    #   but needs further work

    attr_reader :loaded_files
    def initialize(lib_root)
      @lib_root = lib_root
      @loaded_files = []
    end

    def lib_require(base='',&block)
      paths = []
      base_path = File.join(@lib_root, base)
      Array((yield paths, base_path)).each do |path|
        file = File.join(base_path, *Array(path))
        require file
        if @loaded_files.include?(file)
          puts "!!!\tAlready loaded #{file}" if !!(ENV['MF_DEBUG'] =~ /true/i)
        else
          @loaded_files << file
        end
      end
    end

    # TODO: Reduce duplication of directory logic
    def create_dirs(klass)
      class << klass
        Array(yield).each do |dir|
          define_method("#{dir}_dir") do
            File.join(lib_dir,dir)
          end
          module_eval(%Q(def #{dir}_require(&block); lib_require('#{dir}', &block); end))
        end
      end
    end

    def create_artifact_subdirs(klass)
      class << klass
        Array(yield).each do |dir|
          define_method("#{dir.gsub(/[^A-Za-z0-9]/,'')}_dir") do
            File.join(artifact_dir,dir)
          end
        end
      end
    end

    def load_tasks(tasks_relative_path)
      load File.join(@lib_root, 'tasks', *Array(tasks_relative_path))
    end

    def setup
      MetricFu.lib_require { 'configuration' }
      MetricFu.lib_require { 'metric' }
      Dir.glob(File.join(MetricFu.metrics_dir, '**/init.rb')).each{|init_file|require(init_file)}
      # Dir.glob(File.join(MetricFu.reporting_dir, '**/init.rb')).each{|init_file|require(init_file)}
      # # rake is required for
      # # Rcov    : FileList
      # # loading metric_fu.rake
      # require 'rake'

      require 'yaml'
      # require 'redcard'
      # require 'multi_json'

      # MetricFu.configure
      MetricFu.logging_require { 'mf_debugger' }
      Object.send :include, MfDebugger
      # Object.send :extend,  MfDebugger
      MfDebugger::Logger.debug_on = !!(ENV['MF_DEBUG'] =~ /true/i)
      # # Load a few things to make our lives easier elsewhere.
      # # require these first because others depend on them
      # MetricFu.metrics_require   { 'hotspots/hotspot' }
      MetricFu.metrics_require   { 'generator' }
      MetricFu.lib_require   { 'reporter' }
      MetricFu.reporting_require { 'result' }
      # MetricFu.metrics_require   { 'graph' }
      # MetricFu.reporting_require { 'graphs/grapher' }
      # MetricFu.metrics_require   { 'hotspots/analysis/scoring_strategies' }

      # Dir.glob(File.join(MetricFu.lib_dir, '*.rb')).
      #   reject{|file| file =~ /#{__FILE__}|ext.rb/}.
      #   each do |file|
      #     require file
      # end
      # # prevent the task from being run multiple times.
      # unless Rake::Task.task_defined? "metrics:all"
      #   # Load the rakefile so users of the gem get the default metric_fu task
      #   MetricFu.tasks_load 'metric_fu.rake'
      # end
      # Dir.glob(File.join(MetricFu.data_structures_dir, '**/*.rb')).each do |file|
      #   require file
      # end
      # Dir.glob(File.join(MetricFu.logging_dir, '**/*.rb')).each do |file|
      #   require file
      # end
      # Dir.glob(File.join(MetricFu.errors_dir, '**/*.rb')).each do |file|
      #   require file
      # end
      # Dir.glob(File.join(MetricFu.metrics_dir, '**/*.rb')).each do |file|
      #   require(file) unless file =~ /init.rb/
      # end
      # Dir.glob(File.join(MetricFu.reporting_dir, '**/*.rb')).each do |file|
      #   require file
      # end
      # Dir.glob(File.join(MetricFu.formatter_dir, '**/*.rb')).each do |file|
      #   require file
      # end
    end
  end
end

