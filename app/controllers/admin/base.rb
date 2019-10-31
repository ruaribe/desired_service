class Admin::Base < ApplicationController
  before_action :admin_user?

  private def admin_user?
    unless current_user&.admin?
      flash[:danger] = 'アクセス権限がありません'
      redirect_to root_url
    end
  end
end
