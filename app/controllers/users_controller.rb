class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[edit update]
  before_action :correct_user, only: %i[edit update]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    # @user = User.new(params[:user])
    @user = User.new(user_params)

    if @user.save
      # ログインする
      log_in @user

      flash[:success] = 'Welcome to the Sample App!'
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  # beforeアクション

  # ログイン済みユーザーかどうか確認
  def logged_in_user
    unless logged_in?
      flash[:danger] = 'Please log in.'
      redirect_to login_url
    end
  end

  # 正しいユーザーかどうか確認
  def correct_user
    @user = User.find(params[:id])

    # redirect_to(root_url) unless @user == current_user

    redirect_to(root_url) unless current_user?(@user)

      # 同じ意味
      # unless @user == current_user
      #   redirect_to root_url
      # end

      # こちらも同じ意味
      # redirect_to root_url if @user != current_user
  end
end
