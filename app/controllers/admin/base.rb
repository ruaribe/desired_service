class Admin::Base < ApplicationController
  before_action :admin_user?

  private def admin_user?
    redirect_to root_url, notice: 'アクセス権限がありません' unless current_user&.admin?
  end
end
