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

    def scroll_to_text(text)
      text = %("#{text}")

      args = scroll_uiselector("new UiSelector().textContains(#{text})")

      find_element :uiautomator, args
    end
  end
end
