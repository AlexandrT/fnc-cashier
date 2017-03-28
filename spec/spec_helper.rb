require 'appium_lib'
require File.expand_path("../../lib/config.rb", __FILE__)
require File.expand_path("../../lib/test_logger.rb", __FILE__)

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

  config.before(:example, :type => :android) do
    options = {
      caps: {
        platformName: 'Android',
        appActivity: 'screens.splash.SplashView',
        app: Config.apk_path,
        deviceName: 'test-device',
        autoGrantPermissions: true,
        clearSystemFiles: true
      },

      launchTimeout: 4000000
    }

    @driver = Appium::Driver.new(options)
    Appium.promote_appium_methods Object
    @driver.start_driver
    #@driver.manage.timeouts.implicit_wait = 10
  end

  config.after(:example, :type => :android) do
    @driver.remove_app 'com.findnewclient.cashierapp'
    @driver.driver_quit
  end
end
