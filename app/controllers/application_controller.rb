class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  # ログイン済みユーザーかどうか確認
  private def logged_in_user
    unless logged_in?
      store_location
      redirect_to login_url, notice: 'ログインしてください。'
    end
  end
end
