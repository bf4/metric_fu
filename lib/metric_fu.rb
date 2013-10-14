require 'metric_fu/version'
module MetricFu
  APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__),'..'))
  LIB_ROOT = File.join(APP_ROOT,'lib/metric_fu')
  def self.root_dir
    APP_ROOT
  end
  def self.lib_dir
    LIB_ROOT
  end

  require 'metric_fu/loader'
  LOADER = MetricFu::Loader.new(LIB_ROOT)
  def self.lib_require(base='',&block)
    LOADER.lib_require(base,&block)
  end

  LOADER.create_dirs(self) do
    %w(metrics formatter reporting logging errors data_structures tasks)
  end

  # @note artifact_dir is relative to where the task is being run,
  # not to the metric_fu library
  require 'metric_fu/io'
  def self.artifact_dir
    MetricFu::Io::FileSystem.artifact_dir
  end

  LOADER.create_artifact_subdirs(self) do
    %w(scratch output _data)
  end

  def self.tasks_load(tasks_relative_path)
    LOADER.load_tasks(tasks_relative_path)
  end

  LOADER.setup

  def self.reset
    # TODO Don't like how this method needs to know
    # all of these class variables that are defined
    # in separate classes.
    @configuration = nil
    @graph = nil
    @result = nil
  end

  def self.configure
    configuration.tap do |config|
      config.configure_metrics
    end
  end
  #
  # Even though the below class methods are defined on the MetricFu module
  # They are included here as they deal with configuration

  # The @configuration class variable holds a global type configuration
  # object for any parts of the system to use.
  # TODO Configuration should probably be a singleton class
  def self.configuration
    @configuration ||= Configuration.new
  end


end
