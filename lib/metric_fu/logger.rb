require 'logger'
require 'forwardable'
module MetricFu

  class Logger
    extend Forwardable

    def initialize(stdout, stderr)
      @logger = ::Logger.new(stdout, stderr)
      self.debug_on = false
      self.formatter = ->(severity, time, progname, msg){ "#{msg}\n" }
      self.level = 'info'
    end

    def debug_on=(bool)
      self.level = bool ? 'debug' : 'info'
    end

    def debug_on
      @logger.level == Logger::DEBUG
    end

    def_delegators :@logger, :info, :warn, :error, :fatal, :unknown

    LEVELS = {
      'debug' => ::Logger::DEBUG,
      'info'  => ::Logger::INFO,
      'warn'  => ::Logger::WARN,
      'error' => ::Logger::ERROR,
      'fatal' => ::Logger::FATAL,
      'unknown' => ::Logger::UNKNOWN,
    }

    def level=(level)
      @logger.level = LEVELS.fetch(level.to_s.downcase) { level }
    end

    def formatter=(formatter)
      @logger.formatter = formatter
    end

    def log(msg)
      @logger.info '*'*5 + msg.to_s
    end

    def debug(msg)
      @logger.debug '*'*5 + msg.to_s
    end

  end

end
# For backward compatibility
module MfDebugger
  extend self
  Logger = ::MetricFu::Logger.new($stdout, $stderr)

  def mf_debug(msg,&block)
    MfDebugger::Logger.debug(msg, &block)
  end

  def mf_log(msg,&block)
    MfDebugger::Logger.log(msg, &block)
  end

end
