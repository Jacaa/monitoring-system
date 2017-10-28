class UsersController < ApplicationController
  before_action :set_user
  before_action :logged_in_user
  before_action :correct_user

  def edit
  end

  def update
    @user.update_attributes(user_params)
    flash[:info] = "Profile updated."
    redirect_to edit_user_path(@user)
  end

  def destroy
    @user.destroy
    flash[:info] = "Profile deleted!"
    redirect_to root_url
  end

  private 

    def user_params
      params.require(:user).permit(:send_notification, :save_photo)
    end

    def set_user
      @user = User.find(params[:id])
    end

    def correct_user
      redirect_to(root_url) unless correct_user?(@user)
    end

    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to root_url
      end
    end
end
