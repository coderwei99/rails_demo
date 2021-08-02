class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create  
    @user = User.new(user_detail)
    if @user.save
      log_in @user
      flash[:success] = 'let go'
      redirect_to @user
    else
      render :new
    end
  end

  private
    def user_detail
      params.require(:user).permit(:name,:email,:password,:password_confirmation)
    end
end
