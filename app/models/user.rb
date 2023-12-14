class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_messages, class_name: 'Message', foreign_key: 'receiver_id', dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id', dependent: :destroy
  has_many :inverse_friends, through: :inverse_friendships, source: :user

  # Validations
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  def display_posts
    # Return all posts of the user and his/her friends
    Post.where(user: (friends + [self])).order(updated_at: :desc)
  end

  def display_messages_with_a_user(friend)
    # Return all messages between the user and a friend
    sent_messages = Message.where(sender: self, receiver: friend).map do |message|
      {sender: message.sender, receiver: message.receiver, content: message.content, created_at: message.created_at}
    end
    received_messages = Message.where(sender: friend, receiver: self).map do |message|
      {sender: message.sender, receiver: message.receiver, content: message.content, created_at: message.created_at}
    end
    (sent_messages + received_messages).sort_by { |message| message[:created_at] }.reverse
  end

  def display_top_messages_with_a_user(friend, conversation_length = 10)
    # Fetch the latest messages based on conversation_length
    sent_messages = Message.where(sender: self, receiver: friend).order(created_at: :desc).limit(conversation_length)
    received_messages = Message.where(sender: friend, receiver: self).order(created_at: :desc).limit(conversation_length)
  
    # Combine, sort, and then take the top messages based on conversation_length
    all_messages = (sent_messages + received_messages).sort_by { |message| message.created_at }.reverse.take(conversation_length)
  
    # Convert to a format suitable for the view
    all_messages.map do |message|
      { sender: message.sender, receiver: message.receiver, content: message.content, created_at: message.created_at }
    end
  end
end

