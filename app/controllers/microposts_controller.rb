class MicropostsController < ApplicationController
	before_action :logged_in_user, only: [:create, :destroy]
	before_action :correct_user, only: :destroy
	
	def create
		@micropost = current_user.microposts.build(micropost_params)
		if @micropost.save
			flash[:success] = "Micropost created!"
			redirect_to root_url
		else
			@feed_items = []
			render 'static_pages/home'
		end
	end 
	
	def destroy 
		@micropost.destroy
		flash[:success] = "Micropost deleted"
		redirect_to request.referrer || root_url # request.referrer is like request.url - it makes sense because it returns the user to the page where the delete request was made. 
	end
	
	private 
	
	def micropost_params
		params.require(:micropost).permit(:content, :picture) # referring to what can be posted in a micropost.
	end
	
	def correct_user
		@micropost = current_user.microposts.find_by(id: params[:id])
		redirect_to root_url if @micropost.nil?
	end

end