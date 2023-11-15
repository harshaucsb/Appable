class CommentsController < ApplicationController
    before_action :set_comment, only: [:show, :edit, :update, :destroy]
    
    def index
        @comments = Comment.all
    end

    def show
        begin
            @comment = Comment.find(params[:id])
        rescue ActiveRecord::RecordNotFound
            render :json => "404 Not found"
        end
    end

    def new
        @post = Post.find(params[:post_id])
        @comment = Comment.new
    end

    def edit
        @comment = Comment.find(params[:id])

        #if @comment != current_comment
        #    redirect_to root_path, notice: "Sorry, but you are only allowed to edit your own profile."
        #end
    end

    def create
        @post = Post.find(params[:post_id])
        @comment = @post.comments.new(comment_params)
    
        if @comment.save
          redirect_to @post, notice: 'Comment was successfully created.'
        else
          render :new, status: :unprocessable_entity
        end
      end

    def update
        if @comment.update(comment_params)
            redirect_to @comment, notice: 'Comment was successfully updated.'
        else
            render :edit
        end
    end

    def destroy
        @comment.destroy
        redirect_to comments_url, notice: 'Comment was successfully destroyed.'
    end

    private
    
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
        @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
        params.require(:comment).permit(:content, :user_id)
    end

end
