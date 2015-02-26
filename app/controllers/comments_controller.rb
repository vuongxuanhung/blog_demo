class CommentsController < ApplicationController
	before_action :logged_in_user, only: [:create, :destroy]
	def create
		entry = Entry.find params[:comment][:entry_id]
		@comment = current_user.comments.build comment_params
		@comment.entry = entry
		# byebug
		if @comment.save
			redirect_to request.referrer || root_url
		else
			@entry = current_user.entries.build
			@feed_items = current_user.feed.paginate(page: params[:page], per_page: 8)
			render 'static_pages/home'
		end
	end

	def destroy
		comment = current_user.comments.find(params[:id])
		comment.destroy
		respond_to do |format|
			format.html { redirect_to request.referrer}
			format.js
		end
	end

	private
		def comment_params
			params.require(:comment).permit(:content)
		end
end
