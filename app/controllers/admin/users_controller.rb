# frozen_string_literal: true

class Admin::UsersController < Admin::Base

  def index
    @users = User.all.page(params[:page]).per(20)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.desc.page(params[:page]).per(20)
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'ユーザーを削除しました。'
    redirect_to admin_users_url
  end
end
