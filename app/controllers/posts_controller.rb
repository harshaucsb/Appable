class PostsController < ApplicationController
    before_action :set_post, only: [:show, :edit, :update, :destroy]
    
    def index
        @posts = Post.all
    end

    # Method to return user name from the post
    def get_user_name(post)
        @user = User.find(post.user_id)
        return @user.name
    end

    def show
        begin
            @post = Post.find(params[:id])
        rescue ActiveRecord::RecordNotFound
            render :json => "404 Not found"
        end
    end

    def new
        @post = Post.new
    end

    def edit
        @post = Post.find(params[:id])

        #if @post != current_post
        #    redirect_to root_path, notice: "Sorry, but you are only allowed to edit your own profile."
        #end
    end

    def create
        puts "Reached create method of Posts"
        puts post_params
        @post = Post.new(post_params)
        if @post.save
            redirect_to @post, notice: 'Post was successfully created.'
        else
            render :new
        end
    end

    def update
        if @post.update(post_params)
            redirect_to @post, notice: 'Post was successfully updated.'
        else
            render :edit
        end
    end

    def destroy
        @post.destroy
        redirect_to posts_url, notice: 'Post was successfully destroyed.'
    end

    private
    
    # Use callbacks to share common setup or constraints between actions.
    def set_post
        @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
        params.require(:post).permit(:title, :content, :user_id)
    end
end
