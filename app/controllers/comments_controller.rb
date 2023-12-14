class CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_post
    before_action :set_comment, only: [:show, :update, :destroy]

    def show
        begin
            @comment = Comment.find(params[:id])
        rescue ActiveRecord::RecordNotFound
            render :json => "404 Not found"
        end
    end

    def new
        @comment = Comment.new
    end

    def create
        @comment = @post.comments.build(comment_params.merge(user: current_user))
        if @comment.save
            # Handle successful save
            redirect_to @post, notice: 'Comment was successfully created.'
        else
            # Handle save failure
            render :new, status: :unprocessable_entity
        end
    end

    def update
        # Update a comment
        if @comment.user != current_user
            # Handle unauthorized updation
            render :edit
        else
            @comment.update(comment_params)
            # Handle comment deletion
            redirect_to @post, notice: 'Comment was successfully updated.'
        end
    end

    def destroy
        # Delete a comment
        if @post.user != current_user || @comment.user != current_user
            # Handle unauthorized deletion
            redirect_to @comment, notice: 'Only owner of the post/comment is allowed to delete.'
        else
            @comment.destroy
            # Handle comment deletion
            redirect_to @post, notice: 'Comment was successfully destroyed.'
        end
    end

    private

    def set_post
        @post = Post.find(params[:post_id])
    end

    def set_comment
        @comment = Comment.find(params[:id])
    end

    def comment_params
        params.require(:comment).permit(:content)
    end
end
  