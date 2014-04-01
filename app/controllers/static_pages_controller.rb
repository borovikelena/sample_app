class StaticPagesController < ApplicationController
  include SessionsHelper
  def home
  	if signed_in?
  	  @micropost = current_user.microposts.build
      if params[:search]
        feed_items = current_user.feed.search(params[:search])
      else  	 
        feed_items = current_user.feed
      end
      @feed_items = feed_items.paginate(page: params[:page], per_page: 10)
    end
  end

  def help
  end

  def about
  end

end
