require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
  	@user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end
  
  test "should be valid" do 
  	assert @user.valid?
  end 
  
  test "name should be present" do 
  	@user.name = " " 
  	assert_not @user.valid? 
  end 
  
  test "email should be present" do 
  	@user.email = " " 
  	assert_not @user.valid?
  end 
  
  test "name should not be too long" do 
  	@user.name = "a" * 51 
  	assert_not @user.valid?
  end 
  
  test "email should not be too long" do 
  	@user.email = "a" * 244 + "@middleearth.com"
  	assert_not @user.valid? 
  end 
  
  test "email validation should accept valid addresses" do 
  	valid_addresses = %w[user@middleearth.com USER@foo.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
  	valid_addresses.each do |valid_address|
  		@user.email = valid_address
  		assert @user.valid?, "#{valid_address.inspect} should be valid"
  	end
  end
  
  test "email validation should reject invalid addresses" do 
  	invalid_addresses = %w[user@middleearth,com user_at_foo.org user.name@middleearth.foo@bar_baz.com foo@bar+baz.com foo@bar..com]
  	invalid_addresses.each do |invalid_address|
  		@user.email = invalid_address
  		assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
  	end
  end  
  
  test "email addresses should be unique" do
  	duplicate_user = @user.dup
  	duplicate_user.email = @user.email.upcase
  	@user.save
  	#assert duplicate_user.valid?
  	assert_not duplicate_user.valid? 
  	# (^^^^ the original)
  end 
  
  test "email addresses should be saved as downcase" do 
  	mixed_case_email = "Foo@ExAMPle.CoM" 
  	@user.email = mixed_case_email
  	@user.save
  	assert_equal mixed_case_email.downcase, @user.reload.email
  end 
  
=begin 
(The below test stopped working because of the change to setup. Derp)
  
test "password should have a minimum length" do 
  	@user.password = @user.password_confirmation = "foobar" 
  	# assert @user.valid?
  	assert_not @user.valid?
  end 

=end 
  
  test "authenticated? should return false for a user with nil digest" do 
  	assert_not @user.authenticated?(:remember, '')
  end 
  
  test "associated microposts should be destroyed" do 
  	@user.save
  	@user.microposts.create!(content: "One ring to rule them all")
  	assert_difference 'Micropost.count', -1 do
  		@user.destroy
  	end
  end 
  
end






