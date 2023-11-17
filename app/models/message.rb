class Message < ApplicationRecord
    # Associations
    belongs_to :sender, class_name: 'User'
    belongs_to :receiver, class_name: 'User'
  
    # Validations
    validates :content, presence: true
end