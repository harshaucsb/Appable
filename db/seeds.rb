# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#Primary Project

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#################################
# Clean the Tables before Seeding
#################################
puts "DEBUG: Cleaning up all the databases"

#User.delete_all
#ActiveRecord::Base.connection.reset_pk_sequence!('users')
#Post.delete_all
#ActiveRecord::Base.connection.reset_pk_sequence!('posts')
#Comment.delete_all
#ActiveRecord::Base.connection.reset_pk_sequence!('comments')
#Message.delete_all
#ActiveRecord::Base.connection.reset_pk_sequence!('messages')
#Friendship.delete_all
#ActiveRecord::Base.connection.reset_pk_sequence!('friendships')


#################################
# Creating 100 Users
#################################
puts "DEBUG: Creating 1000 Users"

begin
    for i in 1..1000 do
        # puts "Creating user #{i}"
        User.create!(name: "user#{i}" ,email: "user#{i}@example.com", password: "password", password_confirmation: "password")
    end
rescue => e
    puts "An error occurred: #{e.message}"
end



#################################
# Creating 500 Posts
#################################

puts "DEBUG: Creating 500 Posts: Each user creating 5 posts"

#users = User.limit(5)

User.find_each do |user|
    5.times do |j|
      Post.create!(
        user: user,
        title: "Post From #{user.name} - Post No #{j + 1}",
        content: "Content of post  from #{user.name} - Post No #{j + 1}"
      )
    end
end




#################################
# Creating Comments
#################################

puts "DEBUG: Creating Comments on all the posts"

#users = User.limit(10)
#posts =  Post.limit(100)

all_users = User.all.to_a # Convert to array

Post.find_each do |post|
  random_users = all_users.sample(10)
  random_users.each do |user|
    content = "Comment by #{user.name} on #{post.title}"
    Comment.create!(
      user: user,
      post: post,
      content: content
    )
  end
end


#################################
# Creating Friendships
#################################


puts "DEBUG: Friendships for all the users"

User.find_each do |user|
  friends = User.where.not(id: user.id).sample(10)
  friends.each do |friend|
    # Create friendship unless it already exists
    unless Friendship.exists?(user: user, friend: friend) || Friendship.exists?(user: friend, friend: user)
      Friendship.create!(user: user, friend: friend)
    end
  end
end

#################################
# Sending and Receiving Messages
#################################

puts "DEBUG: Sending and receiving messages"

User.find_each do |user|
  recipients = User.where.not(id: user.id).sample(10)
  recipients.each do |recipient|
    # Create a message from user to recipient
    content = "Message from #{user.name} to #{recipient.name}"
    Message.create!(sender: user, receiver: recipient, content: content)
  end
end
