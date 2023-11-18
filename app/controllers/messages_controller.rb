class MessagesController < ApplicationController
    before_action :get_receiver, only: [:new, :create]
  
    def new
      @message = Message.new
    end
  
    def create
      # puts @other_user
      @message = Message.new(message_params)
      @message.sender = current_user
      
      if @message.save
        flash[:success] = 'Message sent successfully.'
        # redirect_to messages_path(user_id: current_user.id)
        puts @message.receiver_id
        redirect_to new_message_path(friend_id: @message.receiver_id)
      else
        flash.now[:error] = @message.errors.full_messages.to_sentence
        render :new
      end
    end

    def chat
      @user = User.find(params[:user_id])
      @friend = User.find(params[:friend_id])
      # You will need to implement a scope or a method to fetch the chat messages
      @chat_messages = Message.chat_between(@user, @friend)
    end
    

    def index
        @user = User.find_by(id: params[:user_id])
        @messages = Message.all
    end
  
    private
  
    def get_receiver
      @other_user = User.find_by(id: params[:friend_id])
    end
  
    def message_params
      params.require(:message).permit(:content, :receiver_id)
    end
end
  