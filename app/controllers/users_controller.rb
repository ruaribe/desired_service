class UsersController < ApplicationController
  before_action :logged_in_user, only: %I[edit update destroy]
  before_action :correct_user, only: %I[edit update]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      redirect_to @user, notice: 'ユーザーを登録しました。'
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.desc
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to @user, notice: 'ユーザー情報を更新しました。'
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_url, notice: 'ユーザーを削除しました。'
  end

  private def user_params
    params.require(:user).permit(:name, :email, :sex, :birthday,
                                 :password, :password_confirmation)
  end

  private def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

end
