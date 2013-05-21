require 'rake'
require 'fileutils'
namespace :metrics do
  desc "Generate all metrics reports"
  task :all do
    MetricFu::Run.new.run
  end

  desc 'Migrate to new artifact directory'
  task :move_metrics_from_legacy_artifact_directory => [] do
    if Dir.exists?(MetricFu.legacy_artifact_dir)
      list = FileList[File.join(MetricFu.legacy_artifact_dir, '**', '*')].existing
      files, dirs = list.partition {|item| File.file?(item) }
      # directory dirs
      file MetricFu.artifact_dir do
        cp files, MetricFu.artifact_dir, :verbose => true
      end
    end
  end
end
