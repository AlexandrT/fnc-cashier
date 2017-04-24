require 'spec_helper'

RSpec.describe "Example test", :type => :android do
  context "" do
    it "through email should be OK" do
      auth

      expect(find_element(:id => "get_code_action")["enabled"]).to eq("false")

      if xpath('//android.widget.Spinner[contains(@resource-id, "country_list")]/android.widget.TextView').text != "Россия"
        find_element(:id => "text1").click

        begin
          xpath('//android.widget.ListView/android.widget.TextView[contains(@text, "Россия")]')
        rescue
          scroll_to("Россия")
        end
      end

      send_code("0000000")

      message = id("message").text

      expect(message).to eq("Введенный номер телефона не зарегистрирован в системе")
    end
  end
end
