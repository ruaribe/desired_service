class PostsController < ApplicationController
  before_action :logged_in_user, only: %I[create update destroy]
  before_action :correct_user, only: :destroy

  def index
    @posts = Post.desc.includes(:user)
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = '投稿しました'
      redirect_to @post.user
    else
      @user = @post.user
      @posts = @user.posts.reload
      render 'users/show'
    end
  end

  def destroy
    @post.destroy
    flash[:success] = '投稿を削除しました。'
    redirect_back(fallback_location: root_url)
  end

  private def post_params
    params.require(:post).permit(:content)
  end

  private def correct_user
    @post = current_user.posts.find_by(id: params[:id])
    redirect_to root_url if @post.nil?
  end
end
