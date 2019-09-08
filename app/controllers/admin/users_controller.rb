# frozen_string_literal: true

class Admin::UsersController < Admin::Base

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.desc
    render 'users/show'
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to admin_users_url, notice: 'ユーザーを削除しました。'
  end
end
