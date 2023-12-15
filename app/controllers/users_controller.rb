class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: [:edit, :show, :update, :destroy]
  
    def index
      cache_key = "all_users#{params[:search]}"
      users = Rails.cache.fetch(cache_key, expires_in: 15.minutes) do
        search_users(params[:search]).to_a
      end

      @pagy_users, @users = pagy_array(users, items: 10)
    end

    def search_users(query)
      if query.present?
        User.where("name LIKE ?", "%#{query}%")
      else
        User.all
      end
    end

    def show
        # Display the user's profile
        begin
          @friends = @user.friends
          
          @pagy_suggestions, @suggestions = pagy(User.where.not(id: @user.id).where.not(id: @friends.pluck(:id)), items: 5)

          @pagy_posts, @posts = pagy(@user.posts.order(created_at: :desc), items: 3)

          if user_signed_in? && current_user == @user
            @pagy_latest_messages, @latest_messages = pagy(Message.where("receiver_id = :user_id", user_id: @user.id), items: 3)
          end
          
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
            Rails.cache.delete("feed_posts_#{current_user.id}")
            @user.destroy
            User.delete(@user)
            redirect_to root_path, notice: 'User was successfully destroyed.'
        end
    end
  
    def add_friend
        # Logic to add a friend
        new_friend = User.find(params[:friend_id])
        
        # Directly create the following without any checks
        current_user.friends << new_friend

        Rails.cache.delete("feed_posts_#{current_user.id}")
        
        # Redirect to the user's page with a success message
        redirect_to user_path(current_user), notice: 'Friend followed successfully.'
    end
  
    def remove_friend
        # Logic to remove a friend
        friend = User.find(params[:friend_id])

        # Remove person from user's following list
        current_user.friends.delete(friend)

        Rails.cache.delete("feed_posts_#{current_user.id}")

        # Redirect to the user's page with a success message
        redirect_to user_path(current_user), notice: 'Friend unfollowed successfully.'
    end
  
    private
  
    def set_user
      @user = User.find(params[:id])
    end
  
    def user_params
      params.require(:user).permit(:name, :email)
    end
  end
  