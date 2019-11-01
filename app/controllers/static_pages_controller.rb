class StaticPagesController < ApplicationController
  def top
    @posts = Post.desc.page(params[:page]).per(20).limit(20).includes(:user, :liked_users)
  end

  def about
  end

  def trend
    @posts = Post.find(Like.group(:post_id).order(Arel.sql('count(post_id) desc')).limit(20).pluck(:post_id))
  end
end
