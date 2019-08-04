class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: 'ユーザーを登録しました。'
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
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
    params.require(:user).permit(:name, :email, :sex, :birthday)
  end

end
