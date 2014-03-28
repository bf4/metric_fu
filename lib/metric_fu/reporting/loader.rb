
  # @note artifact_dir is relative to where the task is being run,
  #   not to the metric_fu library
  require 'metric_fu/io'
  def artifact_dir
    MetricFu::Io::FileSystem.artifact_dir
  end

  def artifact_subdirs
    %w(scratch output _data)
  end

  create_artifact_subdirs(MetricFu) do
    artifact_subdirs
  end
  #
    # Adds method x_dir relative to the metric_fu artifact directory to the given klass
    #   And strips any leading non-alphanumerical character from the directory name
    # @param klass [Class] the klass to add methods for the specified artifact sub-directories
    # @yieldreturn [Array<String>] Takes a list of directories and adds readers for each
    # @example For the artifact sub-directory '_scratch', creates on the klass one method:
    #     ::scratch_dir (which notably has the leading underscore removed)
    def create_artifact_subdirs(klass)
      class << klass
        Array(yield).each do |dir|
          define_method("#{dir.gsub(/[^A-Za-z0-9]/,'')}_dir") do
            File.join(artifact_dir,dir)
          end
        end
      end
    end
