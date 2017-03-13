require 'appium_lib'
require File.expand_path("../../lib/config.rb", __FILE__)
require File.expand_path("../../lib/test_logger.rb", __FILE__)
require 'byebug'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  Dir[File.expand_path("../support/*.rb", __FILE__)].each { |f| require f }

  config.include UiHelpers::Android, type: :android

  #config.before(:context, :type => :android) do
    #@adb = ADBClass.new
    #@adb.start_server
    #sn = @adb.devices[0]
    #@adb.install(Config.apk_path, nil, { :serial => sn  }, 60)
    #@adb.stop_server
  #end

  config.before(:example, :type => :android) do
    options = {
      caps: {
        platformName: 'Android',
        appActivity: 'screens.main.MainActivity',
        #appPackage: 'com.findnewclient.cashierapp',
        app: Config.apk_path,
        deviceName: 'test-device'
      },

      launchTimeout: 40000
    }

    @driver = Appium::Driver.new(options)
    Appium.promote_appium_methods Object
    @driver.start_driver
    #@driver.manage.timeouts.implicit_wait = 10
  end

  config.after(:example, :type => :android) do
    #@driver.remove_app 'com.findnewclient.cashierapp'
    @driver.driver_quit
  end

  #config.after(:context, :type => :android) do
    #byebug
    #@adb.start_server
    #sn = @adb.devices[0]
    #@adb.uninstall('com.findnewclient.cashierapp', { :serial => sn  })
    #@adb.stop_server
  #end
end
