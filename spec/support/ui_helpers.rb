module UiHelpers
  module Android
    def auth
      find_element(:id => "new_user").click
      find_element(:id => "registration_button").click

      sleep(5)
      find_element(:id => "permission_allow_button").click if find_element(:id => "dialog_container").exist
    end

    def scroll_to_text(text)
      text = %("#{text}")

      args = scroll_uiselector("new UiSelector().textContains(#{text})")

      find_element :uiautomator, args
    end
  end
end
