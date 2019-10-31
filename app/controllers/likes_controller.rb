class LikesController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    current_user.liked_posts << post
    flash[:success] = 'いいね！しました。'
    redirect_back(fallback_location: root_url)
  end

  def destroy
    Like.find(params[:id]).destroy
    flash[:success] = 'いいね！を取消しました。'
    redirect_back(fallback_location: root_url)
  end
end
