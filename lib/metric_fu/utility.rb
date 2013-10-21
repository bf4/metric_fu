require 'fileutils'
require 'yaml'
MetricFu.lib_require { 'metric_file' }
module MetricFu
  module Utility
    module_function

    # Removes non-ASCII characters
    def clean_ascii_text(text)
      if text.respond_to?(:encode)
        # avoids invalid multi-byte escape error
        ascii_text = text.encode( 'ASCII', invalid: :replace, undef: :replace, replace: '' )
        # see http://www.ruby-forum.com/topic/183413
        pattern = Regexp.new('[\x80-\xff]', nil, 'n')
        ascii_text.gsub(pattern, '')
      else
        text
      end
    end

    def rm_rf(*args)
      FileUtils.rm_rf(*args)
    end

    def mkdir_p(*args)
      FileUtils.mkdir_p(*args)
    end

    def load_yaml_file(filename)
      return unless File.exists?(filename)
      contents = File.read(filename)
      YAML.load(contents)
    end

    def metric_files
      file_pattern = File.join(MetricFu::Io::FileSystem.directory('data_directory'), '*.yml')
      MetricFu::MetricFile.from_file_pattern(file_pattern)
    end

  end
end
