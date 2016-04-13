require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
	test "full title helper" do 
		assert_equal full_title, "Bilbo Baggins? More Like Bilbo Swaggins"
	end 
end