require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  test "inavlid singup information" do 
  	get signup_path
  	assert_no_difference 'User.count' do 
  		post users_path, user: { name: "", email: "user@invalid", password: "foo", password_confirmation: "bar" }
  	end 
  	assert_template 'users/new'
  end 
  
  test "valid signup information" do 
  	get signup_path 
  	assert_difference "User.count", 1 do 
  		post_via_redirect users_path, user: { name: "Example User", "user@middleearth.com", password: "password", password_confirmation: "password" } 
  	end
  	assert_template 'users/show' 
  	assert is_logged_in? 
  end 
  
  test "error messages appear" do 
  	get signup_path 
  	assert_no_difference 'User.count' do 
  		post users_path, user: { name: "", email: "user@invalid", password: "foo", password_confirmation: "bar" }
  	end 
  	assert_template 'users/new' 
  	assert_select 'div#<CSS id for error explanation>' 
  	assert_select 'div#<CSS class for field with error>' 
  end 
  
  test "flash message appears" do 
  	get signup_path 
  	assert_difference "User.count", 1 do 
  		post users_path, user: { name: "Example User", "user@middleearth.com", password: "password", password_confirmation: "password" } 
  	end
  	assert_template 'users/show'
  	assert_not flash.valid?  
  end 
  
end



