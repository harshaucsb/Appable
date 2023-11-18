class Friendship < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  # Validations
  validates :user_id, presence: true
  validates :friend_id, presence: true, uniqueness: { scope: :user_id }
end