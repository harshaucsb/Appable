class PostsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_post, only: [:show, :edit, :update, :destroy]
  
    def index
        # @posts = Post.all.order(updated_at: :desc)
        @pagy_posts, @posts = pagy(Post.all.order(updated_at: :desc), items: 10)
    end

    def new
        @post = Post.new
    end
  
    def show
        # Show a specific post
        begin
            @post = Post.find(params[:id])
            @pagy_post_comments, @post_comments = pagy(@post.comments.all.order(updated_at: :desc), items: 3)
        rescue ActiveRecord::RecordNotFound
            render :json => "404 Not found"
        end
    end
  
    def create
      @post = current_user.posts.build(post_params)
      if @post.save
        # Handle successful save
        Rails.cache.delete("feed_posts_#{current_user.id}") if post_created?
        redirect_to @post, notice: 'Post was successfully created.'
      else
        # Handle save failure
        render :new
      end
    end
  
    def update
        # Update post
        if @user != current_user
            # Handle unauthorized update
            redirect_to @post, notice: 'Only owner of the post is allowed to update.'
        elsif @post.update(post_params)
            # Handle successful update
            Rails.cache.delete("feed_posts_#{current_user.id}") if post_created?
            redirect_to @post, notice: 'Post was successfully updated.'
        else
            # Handle update failure
            render :edit
        end
    end
  
    def destroy
        if @user != current_user
            # Handle unauthorized deletion
            redirect_to @post, notice: 'Only owner of the post is allowed to delete.'
        else
            @post.destroy
            # Handle post deletion
            Rails.cache.delete("feed_posts_#{current_user.id}") if post_created?
            redirect_to posts_url, notice: 'Post was successfully destroyed.'
        end
    end
  
    private
  
    def set_post
      @post = Post.find(params[:id])
      @user = @post.user
    end
  
    def post_params
      params.require(:post).permit(:title, :content)
    end
end