class User < ActiveRecord::Base
	before_save { self.email = email.downcase } 
	validates :name, presence: true, length: {maximum: 50}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: {maximum: 256}, 
		format: { with: VALID_EMAIL_REGEX },
		uniqueness: { case_sensitive: false }
	#attr_accessor :email, :name, :password, :password_confirmation
	has_secure_password
	validates :password, length: {minimum: 6}
end