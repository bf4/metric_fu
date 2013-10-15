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

    # Load specified task task only once
    #   if and only if rake is required and the task is not yet defined
    #   to prevent the task from being loaded multiple times
    # @params [String] tasks_relative_path, 'metric_fu.rake' by default
    # @params [Hash] options, optional task_name to check if loaded
    def load_tasks(tasks_relative_path, options={task_name: ''})
      if defined?(Rake::Task) and not Rake::Task.task_defined?(options[:task_name])
        load File.join(@lib_root, 'tasks', *Array(tasks_relative_path))
      end
    end

    def setup
      MetricFu.lib_require { 'configuration' }
      MetricFu.lib_require { 'metric' }
      Dir.glob(File.join(MetricFu.metrics_dir, '**/init.rb')).each{|init_file|require(init_file)}

      require 'yaml'

      MetricFu.logging_require { 'mf_debugger' }
      Object.send :include, MfDebugger
      # Object.send :extend,  MfDebugger
      MfDebugger::Logger.debug_on = !!(ENV['MF_DEBUG'] =~ /true/i)
      MetricFu.metrics_require   { 'generator' }
      MetricFu.lib_require   { 'reporter' }
      MetricFu.reporting_require { 'result' }

      load_tasks('metric_fu.rake', task_name: 'metrics:all')
    end
  end
end

