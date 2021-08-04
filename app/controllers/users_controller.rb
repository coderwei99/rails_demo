class UsersController < ApplicationController
  before_action :logged_in_user,only:[:index,:edit,:update,:destroy]
  before_action :correct_user,only:[:edit,:update]

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create  
    @user = User.new(user_detail)
    if @user.save
      # log_in @user
      # flash[:success] = 'let go'
      # redirect_to @user
      
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_detail)
      flash[:success] = '修改成功'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = ' 删除成功'
    redirect_to users.url
  end

  private
    def user_detail
      params.require(:user).permit(:name,:email,:password,:password_confirmation)
    end
    def logged_in_user
      unless loggin?
        store_location
        flash[:danger] = '请登录'
        redirect_to login_url
      end
    end
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
