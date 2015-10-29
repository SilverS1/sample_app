require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  
  def setup
  	ActionMailer::Base.deliveries.clear
  	@user = users(:example)
  end
  
  test "password resets" do 
  	get new_password_reset_path # Goes to the page for password resets. 
  	assert_template 'password_resets/new' # Asserts on password reset page.
  	# Invalid email 
  	post password_resets_path, password_reset: { email: "" } # An invalid email has been entered. 
  	assert_not flash.empty? # Asserts that a warning message has appeared.  
  	assert_template 'password_resets/new'
  	# Valid email
  	post password_resets_path, password_reset: { email: @user.email } # A valid email has been entered. 
  	assert_not_equal @user.reset_digest, @user.reload.reset_digest
  	assert_equal 1, ActionMailer::Base.deliveries.size
  	assert_not flash.empty?
  	assert_redirected_to root_url # Goes to the password reset form.
  	# Password reset form
  	user = assigns(:user) # Means we don't have to add @ before the user anymore.
  	# Wrong email
  	get edit_password_reset_path(user.reset_token, email: "") # An invalid email has been entered. 
  	assert_redirected_to root_url # Returns to password reset page after invalid email entered. 
  	#Inactive user
  	user.toggle!(:activated) # Tests to see if user is an active one. 
  	get edit_password_reset_path(user.reset_token, email: user.email) # Correct email, but inactive user, so failure. 
  	assert_redirected_to root_url # Returns to the password reset page after user is inactive. 
  	# Right email, wrong token
  	get edit_password_reset_path('wrong token', email: user.email) # A wrong token is entered. 
  	assert_redirected_to root_url # Returns to password reset page after incorrect token is entered. 
  	user.toggle!(:activated)
  	#Right email, right token
  	get edit_password_reset_path(user.reset_token, email: user.email) # Correct email and token are entered. 
  	assert_template 'password_resets/edit' # Goes to the password edit page. 
  	assert_select "input[name=email][type=hidden][value=?]", user.email
  	#Invalid password & confirmation
  	patch password_reset_path(user.reset_token), email: user.email, user: {password: "foobaz", password_confirmation: "zaboof" } # The passwords do not match.
  	assert_select 'div#error_explanation' # Renders the error HTML.
  	#Blank password
  	patch password_reset_path(user.reset_token), email: user.email, user: {password: "", password_confirmation: "foobar"} # Correct token is entered, one password is blank.
  	assert_not flash.empty? # Asserts the flash is not empty. This means an error message has appeared. 
  	assert_template 'password_resets/edit' # Returns to the password reset page. 
  	# Valid password & confirmation
  	patch password_reset_path(user.reset_token), email: user.email, user: {password: "foobar", password_confirmation: "foobar"} # Everything is entered correctly.
  	assert is_logged_in? # Asserts user is logged in thereafter. 
  	assert_not flash.empty?
  	assert_redirected_to user
  	
  	
  end 
  
end
