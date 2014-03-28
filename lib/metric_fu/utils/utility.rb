require 'yaml'
require 'fileutils'
module MetricFu
  module Utility
    module_function

    ESCAPE_CODES_PATTERN = Regexp.new('\e\[\d{1,2}m')

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

    def strip_escape_codes(text)
      text.gsub(ESCAPE_CODES_PATTERN, '')
    end

    def rm_rf(*args)
      FileUtils.rm_rf(*args)
    end

    def mkdir_p(*args)
      FileUtils.mkdir_p(*args)
    end

    def glob(*args)
      Dir.glob(*args)
    end

    def load_yaml(file)
      YAML.load_file(file)
    end

    def binread(file)
      File.binread(file)
    end

  end
end
