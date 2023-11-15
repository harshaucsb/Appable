
class User < ApplicationRecord

    has_many :posts, :dependent => :destroy
    has_many :comments, :dependent => :destroy

    # Friendships
    has_many :friendships
    has_many :friends, through: :friendships, source: :friend

    # Inverse friendships
    has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id"
    has_many :inverse_friends, through: :inverse_friendships, source: :user

    # Messages
    has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id'
    has_many :received_messages, class_name: 'Message', foreign_key: 'receiver_id'

    validates :name, presence: true
    validates :email, presence: true

  end