 require 'singleton'
 require 'yaml'
 require 'json'
 require 'ostruct'
 require_relative 'string_inquirer'

class Config
  DEFAULT_ENV = "development"
  include Singleton

  def data
    @data ||= begin
      config_path = File.join(Dir.pwd, 'config.yml')
      config_hash = YAML.load_file(config_path)
      JSON.parse(config_hash[Config.env].to_json, object_class: OpenStruct)
    end
  end

  class << self
    def [](key)
      instance.data.send(key)
    end

    def method_missing(*args)
      instance.data.send(*args)
    end

    def env
      @env ||= begin
        e = ENV["TEST_ENV"]
        e = DEFAULT_ENV if e == "" || e.nil?
        StringInquirer.new(e)
      end
    end
  end
end
