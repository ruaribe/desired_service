class UsersController < ApplicationController
  before_action :logged_in_user, only: %I[edit update destroy]
  before_action :correct_user, only: %I[edit update]

  def index
    @users = User.all.page(params[:page]).per(20)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      flash[:success] = 'ユーザーを登録しました。'
      redirect_to @user
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.desc.page(params[:page]).per(20).includes(:liked_users)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = 'ユーザー情報を更新しました。'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = 'ユーザーを削除しました。'
    redirect_to users_url
  end

  private def user_params
    attrs = [
      :new_profile_picture, :remove_profile_picture,
      :name, :email, :sex, :birthday
    ]

    attrs << :password << :password_confirmation if params[:action] == 'create'
    params.require(:user).permit(attrs)
  end

  private def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
end