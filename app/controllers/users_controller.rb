class UsersController < ApplicationController
  before_action :authenticate_user!

  def edit
    @user = current_user
  end

  def update
    @user = User.find(current_user.id)
    if @user.update_with_password(user_params)
      bypass_sign_in(@user)
      redirect_to root_path
    else
      render "edit"
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
  end
end