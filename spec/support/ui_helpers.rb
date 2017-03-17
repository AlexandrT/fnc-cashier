module UiHelpers
  module Android
    def auth
      find_element(:id => "new_user").click
      find_element(:id => "registration_button").click

      sleep(5)
      begin
        xpath("//android.widget.Button[@text='ALLOW']").click
      rescue Selenium::WebDriver::Error::NoSuchElementError
      end
    end

    def scroll_to_text(text)
      text = %("#{text}")

      args = scroll_uiselector("new UiSelector().textContains(#{text})")

      find_element :uiautomator, args
    end

    def scroll_to_text(text)
      text = %("#{text}")

      args = scroll_uiselector("new UiSelector().textContains(#{text})")

      find_element :uiautomator, args
    end
  end
end
