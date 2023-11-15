class MessagesController < ApplicationController
    # ...
  
    # Display the form for sending a new message
    def new
      @message = Message.new
      receiver_id = params[:receiver_id]
      sender_id = params[:sender_id]
  
      # Check if the sender and receiver are friends
      sender = User.find(sender_id)
      receiver = User.find(receiver_id)
      
      unless sender.friends.include?(receiver)
        flash.now[:error] = 'You can only send messages to your friends.'
        render :new
        return
      end
  
      @friends = sender.friends
    end
  
    # Create a new message
    def create
      @message = Message.new(message_params)
      @message.sender_id = params[:sender_id] # Set the sender to the provided sender_id
  
      # Check if the receiver is a friend of the sender
      receiver = User.find(@message.receiver_id)
      sender = User.find(params[:sender_id])
      unless sender.friends.include?(receiver)
        flash.now[:error] = 'You can only send messages to your friends.'
        render :new
        return
      end
  
      if @message.save
        flash[:success] = 'Message sent successfully.'
        redirect_to messages_path
      else
        flash.now[:error] = 'Message could not be sent.'
        render :new
      end
    end
    # Display the list of messages
    def index
      @received_messages = current_user.received_messages
    end

    private

    def message_params
      params.require(:message).permit(:content, :receiver_id, :sender_id)
    end
    

  end
  