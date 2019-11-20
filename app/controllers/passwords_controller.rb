class PasswordsController < ApplicationController

  def show
    @user = current_user
    redirect_to @user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    current_password = params[:user][:current_password]
    if current_password.present?
      if @user.authenticate(current_password)
        @user.assign_attributes(user_params)
        if @user.save
          flash[:success] = 'パスワードを変更しました。'
          redirect_to @user
        else
          render 'edit'
        end
      else
        @user.errors.add(:current_password, :wrong)
        render 'edit'
      end
    else
      @user.errors.add(:current_password, :blank)
      render 'edit'
    end
  end

  private def user_params
    params.require(:user).permit(
      :current_password,
      :password,
      :password_confirmation
    )
  end
end
