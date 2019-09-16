# frozen_string_literal: true

class Admin::UsersController < Admin::Base

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.desc
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'ユーザーを削除しました。'
    redirect_to admin_users_url
  end
end
