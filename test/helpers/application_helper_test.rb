require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
	test "full title helper" do 
		assert_equal full_title, "Bilbo Baggins? More Like Bilbo Swaggins"
		assert_equal full_title("Help"), "Help | Bilbo Baggins? More like Bilbo Swaggins"
	end 
end