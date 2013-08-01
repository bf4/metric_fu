module MetricFu

  class Flay < Generator

    def emit
      minimum_score_parameter = MetricFu.flay[:minimum_score] ? "--mass #{MetricFu.flay[:minimum_score]} " : ""

      options_string = %Q(#{minimum_score_parameter} #{MetricFu.flay[:dirs_to_flay].join(" ")})
      command = %Q(mf-flay #{options_string})
      mf_debug "** #{command}"
      @output = `#{command}`
    #   original_argv = ARGV.dup
    #   require 'shellwords'
    #   # ARGV.clear; ARGV.concat Shellwords.shellwords(options_string)
    #   args = Shellwords.shellwords('lib')
    #   ARGV.clear
    #   ARGV.concat(args)
    #   p args

    #   require 'rubygems'
    #   require 'metric_fu_requires'
    #   version = MetricFu::MetricVersion.flay
    #   gem 'flay', version
    # require 'flay'

    # flay = ::Flay.new #::Flay.parse_options

    # files = ::Flay.expand_dirs_to_files(['lib'])
    # p files

    # flay.process(*files)
    # flay.report
    # # @output = MfDebugger::Logger.capture_output { flay.report }
    #   # gem_name = 'flay'
    #   # library_name = 'flay'
    #   # @output = MfDebugger::Logger.capture_output { load Gem.bin_path(gem_name, library_name, version) }
    end

    def analyze
      @matches = @output.chomp.split("\n\n").map{|m| m.split("\n  ") }
    end

    def to_h
      target = []
      total_score = @matches.shift.first.split('=').last.strip
      @matches.each do |problem|
        reason = problem.shift.strip
        lines_info = problem.map do |full_line|
          name, line = full_line.split(":")
          {:name => name.strip, :line => line.strip}
        end
        target << [:reason => reason, :matches => lines_info]
      end
      {:flay => {:total_score => total_score, :matches => target.flatten}}
    end
  end
end
