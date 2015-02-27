class EntriesController < ApplicationController
	before_action :logged_in_user, only: [:create, :destroy]
	before_action :correct_user, only: :destroy
	def create
		@entry = current_user.entries.build(entry_params)
		if @entry.save
			flash[:success] = "Entry created"
			redirect_to root_url
		else
			@feed_items = current_user.feed.paginate(page: params[:page], per_page: 8)
			@comment = current_user.comments.build if logged_in?
			render 'static_pages/home'
		end
	end

	def destroy
		@entry.destroy
		flash[:success] = "Entry deleted"
		respond_to do |format|
			format.html { redirect_to request.referrer || root_url }
			format.js
		end
	end

	private
		def entry_params
			params.require(:entry).permit(:title, :content, :picture)
		end

		def correct_user
			@entry = current_user.entries.find_by(id: params[:id])
			redirect_to root_url if @entry.nil?
		end
end
