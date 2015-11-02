require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

	def setup
		ActionMailer::Base.deliveries.clear
	end
  
  test "inavlid singup information" do 
  	get signup_path
  	assert_no_difference 'User.count' do 
  		post users_path, user: { name: "", email: "user@invalid", password: "foo", password_confirmation: "bar" }
  	end 
  	assert_template 'users/new'
  	assert_select 'div#error_explanation'
  	assert_select 'div.field_with_errors'
  end 
  
  test "valid signup information with account activation" do 
  	get signup_path 
  	assert_difference "User.count", 1 do 
  		post users_path, user: { name: "Example User", "user@example.com", password: "password", password_confirmation: "password" } 
  	end
  	assert_equal 1, ActionMailer::Base.deliveries.size
  	user = assigns(:user)
  	assert_not user.activated?
  	log_in_as (user)
  	assert_not is_logged_in?
  	get edit_account_activation_path("invalid token")
  	assert_not is_logged_in?
  	get edit_account_activation_path(user.activation_token, email: "wrong")
  	assert_not is_logged_in?
  	get edit_account_activation_path(user.activation_token, email: user.email)
  	assert user.reload.activated?
  	follow_redirect!
  	assert_template 'users/show' 
  	assert is_logged_in? 
  end 
  
=begin
  
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
=end 
  
end



