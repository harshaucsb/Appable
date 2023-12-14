class HomeController < ApplicationController
  def index
    if user_signed_in?
      @pagy_feed_posts, @feed_posts = pagy(Post.where(user: (current_user.friends + [current_user])).order(updated_at: :desc), items: 10)      
    end
  end
end
