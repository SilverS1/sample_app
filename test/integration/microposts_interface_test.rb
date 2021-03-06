require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup 
  	@user = users(:example)
  end
  
  test "micropost interface" do 
  	log_in_as(@user) 
  	get root_path
  	assert_select 'div.pagination'
  	assert_no_difference 'Micropost.count' do
  		post microposts_path, micropost: {content: ""}
  	end
  	assert_select 'div#error_explanation'
  	content = "This micropost really ties the room together!" 
  	assert_difference 'Micropost.count', 1 do
  		post microposts_path, micropost: {content: content}
  	end
  	assert_redirected_to root_url
  	follow_redirect!
  	assert_match content, response.body
  	assert_select 'a', text: 'delete'
  	first_micropost = @user.microposts.paginate(page: 1).first
  	assert_difference 'Micropost.count', -1 do
  		delete micropost_path(first_micropost)
  	end
  	get user_path(users(:dumbledore))
  	assert_select 'a', text: 'delete', count: 0
  end

=begin
  
  test "micropost sidebar count" do 
  	log_in_as(@user)
  	get root_path
  	assert_match "#{@users} microposts", response.body
  	other_user = users(:darren)
  	log_in_as other_user
  	get root_path
  	assert_match "0 microposts", response.body
  	other_user.microposts.create!(content: "A micropost!")
  	get root_path
  	assert_match "#{@other_user} microposts", response.body
  end
  
=end
  
  
end
