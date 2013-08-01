#!/usr/bin/env rake
require 'bundler/setup'


Dir['./gem_tasks/*.rake'].each do |task|
  import(task)
end

# $LOAD_PATH << '.'
begin
  require 'spec/rake/spectask'
  desc "Run all specs in spec directory"
  Spec::Rake::SpecTask.new(:spec) do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
  end
rescue LoadError
  require 'rspec/core/rake_task'
  desc "Run all specs in spec directory"
  RSpec::Core::RakeTask.new(:spec)
end

require File.expand_path File.join(File.dirname(__FILE__),'lib/metric_fu')

# task :default => :spec

require 'rake/clean'

@legacy_directory = 'tmp/metric_fu'
@new_directory = '_metric_fu_data'
CLOBBER.include(@new_directory)

SRC_FILES = FileList["#{@legacy_directory}/**/*"]
DEST_FILES = SRC_FILES.pathmap("%{#{@legacy_directory},#{@new_directory}}p")

directory @new_directory

SRC_FILES.zip(DEST_FILES).each do |src, dest|
  file dest => [src, @new_directory] do
    begin
      cp src, dest
    rescue Errno::ENOTDIR => e
      STDERR.puts "Failed copying #{src} to #{dest} with not a directory #{e.class}"
    end
  end
end

task :update => DEST_FILES
task :default => :update
