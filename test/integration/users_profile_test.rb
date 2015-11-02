require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
 include ApplicationHelper
 
 def setup 
 	@user = users(:example)
 end
 
 test "profile display" do 
 	get user_path(@user)
 	assert_template 'users/show' # Shows all users.
 	assert_select 'title', full_title(@user.name) # Asserts that the title is the users name.
 	assert_select 'h1', text: @user.name # Asserts that the first header is the users name. 
 	assert_select 'h1>img.gravatar' # Asserts that in the h1 marker the gravatar is shown.
 	assert_match @user.microposts.count.to_s, response.body # Chanings microposts into symbol. Asserts that the microposts are somewhere on the page.
 	assert_select 'div.pagination' # Asserts that paginate process has been chosen for the div. 
 	@user.microposts.paginate(page: 1).each do |micropost|
 		assert_match micropost.content, response.body # Paginates the microposts. 
 	end
 end
 
 
end
