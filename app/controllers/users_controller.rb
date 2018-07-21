class UsersController < ApplicationController
  # ページ表示前にログインユーザーか確認し、未ログインの場合ログインページに飛ばす
  before_action :logged_in_user, only: %i[index edit update destroy]

  # ログインユーザーと別ユーザーのページを開こうとした場合、root_urlに飛ばす
  before_action :correct_user, only: %i[edit update]

  # ユーザー削除は管理者だけ
  before_action :admin_user, only: :destroy

  def index
    # @users = User.all
    @users = User.paginate(page: params[:page])
  end

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
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
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

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User deleted'
    redirect_to users_url
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
      store_location
      flash[:danger] = 'Please log in.'
      redirect_to login_url
    end
  end

  # 正しいユーザーかどうか確認して、異なる場合root_urlへ飛ばす
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)

    # 別の書き方
    # redirect_to(root_url) unless @user == current_user
    #
    # 同じ意味
    # unless @user == current_user
    #   redirect_to root_url
    # end
    #
    # こちらも同じ意味
    # redirect_to root_url if @user != current_user
  end

  # 管理者かどうか確認
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

end
