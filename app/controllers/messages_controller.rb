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
      redirect_to root_path # Redirect to the homepage or another appropriate path after sending the message
    else
      flash.now[:error] = @message.errors.full_messages.to_sentence
      render :new
    end
  end

  # Optionally, you can add an index action if you plan to display all messages.
  def index
  #   # This will need corresponding view `index.html.erb` under `messages` folder.
  #   # You can adjust the logic to show the messages for a user or all messages, etc.
  #   # For now, it will just get all messages.
    @messages = Message.all
  end

  private

  def load_users
    @users = User.all # Load all users for the form selections
  end

  def message_params
    #params.require(:message).permit(:content, :receiver_id, :sender_id)
    params.require(:message).permit(:content, :receiver_id)
  end

    # GET /user_messages/:user_id
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

  