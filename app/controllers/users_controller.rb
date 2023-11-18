class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: [:edit, :show, :update, :destroy, :friends]
  
    def index
        @users = User.all
    end

    def show
        # Display the user's profile
        begin
            @friends = @user.friends
            # Fetch all other users except the myself and my friends
            friend_ids = current_user.friends.pluck(:id)
            user_and_friend_ids = friend_ids << current_user.id
            @other_users = User.where.not(id: user_and_friend_ids)
        rescue ActiveRecord::RecordNotFound
            render :json => "404 Not found"
        end
    end
  
    def update
        if @user != current_user
            redirect_to users_url, notice: "Sorry, but you are only allowed to edit your own profile."
        else
            # Update user information
            if @user.update(user_params)
                redirect_to @user, notice: 'User was successfully updated.'
            else
                render :edit, status: :unprocessable_entity
            end
        end
    end

    def edit
        if @user != current_user
           redirect_to users_url, notice: "Sorry, but you are only allowed to edit your own profile."
        end
    end
  
    def destroy
        # Delete user account
        if @user != current_user
            redirect_to users_url, notice: "Sorry, but you are only allowed to edit your own profile."
        else
            @user.destroy
            User.delete(@user)
            redirect_to root_path, notice: 'User was successfully destroyed.'
        end
    end

    def friends
        # Display the user's friends
        begin
            @friends = @user.friends
        rescue ActiveRecord::RecordNotFound
            render :json => "404 Not found"
        end
    end
  
    def add_friend
        # Logic to add a friend
        new_friend = User.find(params[:friend_id])
        
        # Directly create the following without any checks
        current_user.friends << new_friend
        
        # Redirect to the user's page with a success message
        redirect_to user_path(current_user), notice: 'Friend followed successfully.'
    end
  
    def remove_friend
        # Logic to remove a friend
        friend = User.find(params[:friend_id])

        # Remove person from user's following list
        current_user.friends.delete(friend)

        # Redirect to the user's page with a success message
        redirect_to user_path(current_user), notice: 'Friend unfollowed successfully.'
    end

    def show_messages
        @sent_messages = @user.sent_messages
        @received_messages = @user.received_messages
    end
  
    private
  
    def set_user
      @user = User.find(params[:id])
      @friends = @user.friends
    end
  
    def user_params
      params.require(:user).permit(:name, :email)
    end
  end
  