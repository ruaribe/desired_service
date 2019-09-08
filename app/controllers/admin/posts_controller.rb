# frozen_string_literal: true

class Admin::PostsController < Admin::Base

  def index
    @posts = Post.desc.includes(:user)
  end

  def destroy
    post = Post.find_by(id: params[:id])
    post.destroy
    redirect_back(fallback_location: root_url, notice: '投稿を削除しました。')
  end
end
