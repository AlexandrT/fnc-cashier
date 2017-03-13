require 'singleton'
require 'logger'
require 'time'

class TestLogger
  include Singleton

  def self.method_missing(name, *args, &block)
    instance.logger.send(name, *args, &block)
  end

  def logger
    @logger #||= create
  end

  def initialize
    @logger = Logger.new(File.new("#{Config.log_file}", 'w'))
    @logger.level = Logger::DEBUG
    @logger.formatter = proc do |severity, datetime, progname, msg|
      date_format = datetime.strftime("%Y-%m-%d %H:%M:%S")
      if severity == "INFO" or severity == "WARN"
        "[#{date_format}] #{severity}  (#{progname}): #{msg}\n"
      else
        "[#{date_format}] #{severity} (#{progname}): #{msg}\n"
      end
    end

    @logger
  end
end

