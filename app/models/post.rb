
class Post < ApplicationRecord

  has_many :comments, :dependent => :destroy
  belongs_to :user

  validates :title, :content, :user_id, presence: true
end