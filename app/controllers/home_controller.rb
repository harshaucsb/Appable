class HomeController < ApplicationController
  def index
    if user_signed_in?
      cache_key = "feed_posts_#{current_user.id}"
      all_feed_posts = Rails.cache.fetch(cache_key, expires_in: 15.minutes) do
        Post.where(user: (current_user.friends + [current_user])).order(updated_at: :desc).to_a
      end

      # Use the custom pagination method
      @pagy_feed_posts, @feed_posts = pagy_array(all_feed_posts, items: 10)
    end
  end
end
