module UiHelpers
  module Android
    def auth
      find_element(:id => "registration_button").click
    end

    def scroll_to_text(text)
      text = %("#{text}")

      args = scroll_uiselector("new UiSelector().textContains(#{text})")

      find_element :uiautomator, args
    end

    def send_code(phone)
      id("phone_field").send_keys(phone)
      id("get_code_action").click

      xpath("//android.widget.Button[contains(@text, 'ОК')]").click
    end
  end
end
