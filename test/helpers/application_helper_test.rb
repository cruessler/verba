require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "bootstrap_flash" do
    flash.alert = "Error message"

    # `assert_select` runs the assertion against the element returned by
    # `document_root_element`.
    self.class.class_exec do
      def document_root_element
        Nokogiri::HTML::Document.parse(bootstrap_flash).root
      end
    end

    assert_select "div.alert-danger", /Error message/
  end
end
