# frozen_string_literal: true

class Admin::PostsController < Admin::Base

  def index
    @posts = Post.desc.includes(:user, :liked_users)
  end

  def destroy
    post = Post.find_by(id: params[:id])
    post.destroy
    flash[:success] = '投稿を削除しました。'
    redirect_back(fallback_location: root_url)
  end
end
