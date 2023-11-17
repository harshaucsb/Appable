class MessagesController < ApplicationController
    before_action :load_users, only: [:new, :create]
  
    def new
      @message = Message.new
    end
  
    def create
      @message = Message.new(message_params)
      @message.sender = current_user
      
      if @message.save
        flash[:success] = 'Message sent successfully.'
        redirect_to messages_path(user_id: current_user.id)
      else
        flash.now[:error] = @message.errors.full_messages.to_sentence
        render :new
      end
    end

    def index
        @user = User.find_by(id: params[:user_id])
        @messages = Message.all
    end
  
    private
  
    def load_users
      @users = User.all # Load all users for the form selections
    end
  
    def message_params
      params.require(:message).permit(:content, :receiver_id)
    end

    def user_messages
      @user = User.find_by(id: params[:user_id])
      if @user
        @sent_messages = @user.sent_messages
        @received_messages = @user.received_messages
      else
        redirect_to root_path, alert: 'User not found'
      end
    end
end
  