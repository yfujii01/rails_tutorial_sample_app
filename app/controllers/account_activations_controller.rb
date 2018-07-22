class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])

    # 以下の条件をすべて満たす場合にアクティベーションの後ログインする
    # 引数emailの一致するユーザーがDBに存在する
    # ユーザーがアクティベーションされていない
    # ユーザーのトークンがダイジェストと一致する
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
