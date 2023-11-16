class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    
    def index
        @users = User.all
    end

    def show
        begin
            @user = User.find(params[:id])
            @friends = @user.friends + @user.inverse_friends
            # Fetch all other users except the current one
            @other_users = User.where.not(id: @user.id)
        rescue ActiveRecord::RecordNotFound
            render :json => "404 Not found"
        end
    end

    def add_friend
        # Assuming params[:user_id] contains the ID of the user who is to become a friend
        user = User.find(params[:user_id]) 
        friend = User.find(params[:friend_id])
        
        # Directly create the following without any checks
        user.friends << friend
        
        # Redirect to the user's page with a success message
        redirect_to user_path(user), notice: 'Friend followed successfully.'
    end

    def remove_friend
        user = User.find(params[:user_id])
        friend = User.find(params[:friend_id])
    
        # Remove person from user's following list
        user.friends.delete(friend)
    
        # Redirect to the user's page with a success message
        redirect_to user_path(user), notice: 'Friend unfollowed successfully.'
    end

    def show_messages
        @user = User.find(params[:id])
        @sent_messages = @user.sent_messages
        @received_messages = @user.received_messages
    end

    def new
        @user = User.new
    end

    def edit
        @user = User.find(params[:id])

        #if @user != current_user
        #    redirect_to root_path, notice: "Sorry, but you are only allowed to edit your own profile."
        #end
    end

    def friends
        @user = User.find(params[:id])
        @friends = @user.friends + @user.inverse_friends
    end

    def create
        puts "Reached create method of Users"
        puts user_params
        @user = User.new(user_params)
        if @user.save
            redirect_to @user, notice: 'User was successfully created.'
        else
            puts "reached invalid case"
            render :new, status: :unprocessable_entity # 422 error
        end
    end

    def update
        if @user.update(user_params)
            redirect_to @user, notice: 'User was successfully updated.'
        else
            render :edit
        end
    end

    def destroy
        puts "Reached destroy method"
        @user = User.find(params[:id])
        @user.destroy
        User.delete(@user)
        puts users_url
        redirect_to users_url, notice: 'User was successfully destroyed.'
    end

    private
    
    # Use callbacks to share common setup or constraints between actions.
    def set_user
        @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
        params.require(:user).permit(:name, :email)
    end
end
