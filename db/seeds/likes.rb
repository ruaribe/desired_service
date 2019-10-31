# frozen_string_literal: true

users = User.order(:created_at).take(6)
posts = Post.order(created_at: :desc).take(6)
users.each do |user|
  posts.each do |post|
    user.liked_posts << post
  end
end
