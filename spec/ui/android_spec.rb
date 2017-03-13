require 'spec_helper'
require 'byebug'

RSpec.describe "Example test", :type => :android do
  context "" do
    it "through email should be OK" do
      auth

      expect(find_element(:id => "get_code_action")["enabled"]).to eq("false")

      find_element(:id => "text1").click
      scroll_to_text("Russia")
    end
  end
end
