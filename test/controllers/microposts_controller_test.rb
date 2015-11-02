require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase

	def setup 
		@micropost = microposts(:ring)
	end 
	
	test "should redirect create when not logged in" do 
		assert_no_difference 'Micropost.count' do 
			post :create, micropost: { content: "Lorem ipsum" }
		end
		assert_redirected_to login_url # Because we have not logged in the user, it will redirect the user to the login page.
	end 
	
	test "should redirect destroy when not logged in" do 
		assert_no_difference 'Micropost.count' do 
			post :destroy, id: @micropost
		end
		assert_redirected_to login_url
	end
	
	test "should redirect destroy for wrong micropost" do
		log_in_as(users(:example))
		micropost = microposts(:firefly)
		assert_no_difference 'Micropost.count' do
			delete :destroy, id: micropost
		end
		assert_redirected_to root_url
	end


end
