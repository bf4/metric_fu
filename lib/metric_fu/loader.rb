module MetricFu
  class Loader

    # Load specified task task only once
    #   if and only if rake is required and the task is not yet defined
    #   to prevent the task from being loaded multiple times
    # @param tasks_relative_path [String] 'metric_fu.rake' by default
    # @param options [Hash] optional task_name to check if loaded
    # @option options [String] :task_name The task_name to load, if not yet loaded
    def load_tasks(tasks_relative_path, options={task_name: ''})
      if defined?(Rake::Task) and not Rake::Task.task_defined?(options[:task_name])
        load File.join(@lib_root, 'tasks', *Array(tasks_relative_path))
      end
    end

    def setup
      MetricFu.logging_require { 'logger' }
      Object.send :include, MfDebugger
      MfDebugger::Logger.debug_on = !!(ENV['MF_DEBUG'] =~ /true/i)

      MetricFu.lib_require { 'configuration' }
      MetricFu.lib_require { 'metric' }

      Dir.glob(File.join(MetricFu.metrics_dir, '**/init.rb')).each{|init_file|require(init_file)}

      MetricFu.configuration.configure_metrics
      load_user_configuration

      MetricFu.lib_require       { 'reporter' }
      MetricFu.reporting_require { 'result' }

      MetricFu.load_tasks('metric_fu.rake', task_name: 'metrics:all')
    end

    def load_user_configuration
      file = File.join(MetricFu.run_dir, '.metrics')
      load file if File.exist?(file)
    end

  end
end
