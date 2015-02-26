class StaticPagesController < ApplicationController
  def home
  	if logged_in?
  		@entry = current_user.entries.build if logged_in?
  		@feed_items = current_user.feed.paginate(page: params[:page], per_page: 8)
      @comment = current_user.comments.build if logged_in?
      
  	end
  end

  def help
  end

  def about
  end
end
